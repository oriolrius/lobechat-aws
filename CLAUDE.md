# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat Local Stack — self-hosted AI chat platform composed of: LobeChat UI on Postgres, Casdoor SSO, MinIO object storage, **Qdrant** vector DB, **Hayhooks** for serving Haystack pipelines (REST + MCP), local **vLLM** running **Gemma 4 E4B** with native function calling, and **MCPHub** aggregating ~10 stdio + remote MCP servers (ssh-exec, notion, qdrant, haystack, infrastructure-diagrams, d2, playwright, filesystem, minio, aws-resources, aws-documentation). Version managed with Commitizen (currently v0.5.2).

## Common Commands

### Docker Stack
```bash
docker compose up -d              # Start entire stack
docker compose down               # Stop stack
docker compose logs -f lobe-chat  # View LobeChat logs
docker compose restart <service>  # Restart specific service

# After editing dockerfiles/mcphub.Dockerfile:
docker compose build mcphub
docker compose down mcphub && docker compose up -d mcphub
# (compose restart does not always reload mcp_settings.json — prefer down/up)
```

### Testing
```bash
uv run --group test pytest tests/ -v                    # Run all tests
uv run --group test pytest tests/test_vllm.py -v        # Run single test file
uv run --group test pytest tests/test_vllm.py::test_health -v  # Run single test
```

### Database Migrations (dbmate)
```bash
# First time setup: download dbmate binary and install postgresql-client-16
mkdir -p contrib && curl -fsSL https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64 -o contrib/dbmate && chmod +x contrib/dbmate
sudo apt-get install -y postgresql-client-16

# Create new migration
./db/migrate new create_users

# Run pending migrations
./db/migrate up

# Rollback last migration
./db/migrate rollback

# Check migration status
./db/migrate status

# Dump current schema to db/schema.sql
./db/migrate dump

# Dump current data to db/seed.sql
./db/migrate dump-seed

# Recreate database from schema + seed + migrations
./db/migrate drop      # Drop existing database
./db/migrate load      # Load db/schema.sql
./db/migrate load-seed # Load db/seed.sql
./db/migrate up        # Apply any pending migrations
```

Migrations are stored in `db/migrations/` as plain SQL with `-- migrate:up` and `-- migrate:down` sections. The `db/schema.sql` is the schema snapshot and `db/seed.sql` contains initial data for rebuilding the database from scratch.

### Git & Versioning
```bash
git config core.hooksPath .githooks  # Enable commit validation hook
cz commit                            # Interactive conventional commit
cz bump                              # Bump version based on commits
cz changelog                         # Generate CHANGELOG.md
```

Commit format: `type(scope)?: description` where type is feat/fix/docs/style/refactor/test/build/ci/chore. Breaking changes use `!` suffix (e.g., `feat!:`).

## Architecture

**Services (docker-compose.yml):**
- **lobe-chat** (47000): Next.js chat application with database backend. `FEATURE_FLAGS=-changelog,-check_updates` set to suppress the changelog modal.
- **casdoor** (47002): SSO authentication provider
- **mcphub** (47008): MCP server hub. Built locally from `dockerfiles/mcphub.Dockerfile` (extends `samanhappy/mcphub:latest` with graphviz, libgraphviz-dev, gcc, docker.io).
- **vllm** (47007): Local GPU-based LLM inference. Pinned to `vllm/vllm-openai:gemma4`, model `google/gemma-4-E4B-it`, with `--tool-call-parser gemma4 --reasoning-parser gemma4` for native function calling.
- **minio** (47005 API / 47006 Console): S3-compatible object storage
- **postgres** (47003, named `shared-postgres`): shared by all services (lobechat, casdoor)
- **qdrant** (47010 REST / 47011 gRPC): vector database, persisted to `./data/qdrant`
- **hayhooks** (47012): Haystack pipelines exposed as REST (FastAPI; Swagger at `/docs`)
- **hayhooks-mcp** (47013): same image, started with `hayhooks mcp run` so the deployed Haystack pipelines are also reachable as an MCP server at `/mcp`. Installs `hayhooks[mcp]==1.1.0` extras at start.

**MCP Servers via MCPHub** (registry: `config/mcp_settings.json`):
- ssh-exec: SSH command execution (whitelisted commands)
- notion-mcp: Notion database integration (token via `OPENAPI_MCP_HEADERS`)
- aws-resources-operations: AWS boto3 operations
- aws-documentation: AWS docs search
- playwright: Browser automation & screenshots
- pickstar-2002-minio-mcp: MinIO S3 operations
- filesystem: Local file access
- qdrant-mcp: stdio `mcp-server-qdrant`, points at the `rag-demo` collection
- haystack-mcp: streamable-http to `hayhooks-mcp:1417/mcp`
- infrastructure-diagrams: stdio `uvx infrastructure-diagram-mcp-server` (Python `diagrams` package + Graphviz)
- d2: stdio `docker run ghcr.io/h0rv/d2-mcp:main` (D2 diagram language)

**Data Flow:** LobeChat → Casdoor (auth) → Postgres (data) → MinIO (files) → MCPHub (tools) → {qdrant, hayhooks, vLLM/OpenRouter/Meridian, …}. RAG path: LobeChat → MCPHub → qdrant-mcp → Qdrant `rag-demo` (or → haystack-mcp → Hayhooks → Qdrant for pipeline-driven retrieval).

## Key Configuration Files

- `config/mcp_settings.json`: MCPHub server configuration with security restrictions. To add a new MCP server (and surface it inside LobeChat), follow `docs/mcp-onboarding.md` — both layers (MCPHub config + LobeChat `user_installed_plugins` row) must be touched.
- `dockerfiles/mcphub.Dockerfile`: extends `samanhappy/mcphub:latest` with system deps required by stdio MCP servers (graphviz, libgraphviz-dev, gcc — extend here when adding more)
- `docs/mcp-onboarding.md`: end-to-end MCP registration guide (transport choice, MCPHub entry, LobeChat plugin row, agent wiring, sanity checks, troubleshooting)
- `docs/mcp-d2.md`: agent guide for `mcphub-d2` (D2 diagram language) — when to use, role prompt, sample prompts
- `docs/mcp-diagrams.md`: agent guide for `mcphub-diagrams` (Python `diagrams` + Graphviz) — when to use, role prompt, sample prompts
- `docs/agent-cloud-diagrams.md`: pre-built LobeChat agent (`agt_DiagMinio01` — Cloud Diagram Assistant) that renders diagrams and uploads PNGs to MinIO so the image renders inline in chat. Reuses the screenshot-agent pattern (path-variable trick + public bucket policy).
- `docs/agent-rag-sage.md`: pre-built LobeChat agent (`agt_RagSage01` — RAG Sage 📚) that grounds answers in the `rag-demo` Qdrant corpus and renders the synthesis as a `lobe-artifacts` markdown artifact. Corpus content is discovered dynamically via `qdrant-find` probes, so adding/removing documents requires no prompt edit.
- `docs/lobechat-assistants.md`: generic recipe for creating / updating / deleting LobeChat agents from outside the UI by inserting `agents` + `sessions` + `agents_to_sessions` rows into Postgres. `pg_read_file` trick for long system prompts.
- `config/init_data.json`: Casdoor SSO initial data
- `config/init-postgres.sql`: Database initialization (creates lobechat, casdoor DBs)
- `db/migrate`: Database migration wrapper script (uses dbmate)
- `db/schema.sql`: Database schema snapshot (for recreating DB)
- `db/seed.sql`: Database seed data (for recreating DB)
- `db/migrations/`: Incremental SQL migration files
- `patches/route.js`: LobeChat hotfix for MCP session retry logic
- `.env.example`: Environment variable template

## Environment Setup

1. `cp .env.example .env` and configure secrets (min 32 chars for `KEY_VAULTS_SECRET`, `NEXT_AUTH_SECRET`)
2. `HF_TOKEN` — vLLM model downloads (gated Gemma 4 family)
3. `OPENROUTER_API_KEY` — external LLM / embedding endpoint
4. `OPENAPI_MCP_HEADERS` — Notion bearer token consumed by `notion-mcp`. Format: `{"Authorization":"Bearer ntn_…","Notion-Version":"2022-06-28"}`. Pulled from Bitwarden item "Notion API Keys" in this setup.
5. AWS credentials auto-mounted from `~/.aws` into `mcphub` (RW so refresh persists)
6. Optional: Anthropic provider configured via [Meridian](../meridian/README.md). API key stored at `~/esade/meridian/api-key.txt`; LobeChat row in `ai_providers` (`id='anthropic'`) points at `http://wsl.ymbihq.local:3456`.

## Port Reference

| Port  | Service          |
|-------|------------------|
| 47000 | LobeChat         |
| 47002 | Casdoor          |
| 47003 | PostgreSQL       |
| 47005 | MinIO API        |
| 47006 | MinIO Console    |
| 47007 | vLLM             |
| 47008 | MCPHub           |
| 47010 | Qdrant REST      |
| 47011 | Qdrant gRPC      |
| 47012 | Hayhooks REST    |
| 47013 | Hayhooks MCP     |
