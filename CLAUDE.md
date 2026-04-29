# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat Local Stack - A self-hosted AI chat platform with PostgreSQL, Casdoor SSO, MinIO storage, vLLM inference, and MCP server integrations. Version managed with Commitizen (currently v0.5.2).

## Common Commands

### Docker Stack
```bash
docker compose up -d              # Start entire stack
docker compose down               # Stop stack
docker compose logs -f lobe-chat  # View LobeChat logs
docker compose restart <service>  # Restart specific service
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
- **lobe-chat** (47000): Next.js chat application with database backend
- **casdoor** (47002): SSO authentication provider
- **mcphub** (47008): MCP server hub routing to 7 MCP servers
- **vllm** (47007): Local GPU-based LLM inference (Gemma 3 270M)
- **minio** (47005/47006): S3-compatible object storage
- **postgres** (internal): pgvector database shared by all services

**MCP Servers via MCPHub:**
- ssh-exec: SSH command execution (whitelisted commands only)
- aws-resources-operations: AWS boto3 operations
- aws-documentation: AWS docs search
- playwright: Browser automation & screenshots
- pickstar-2002-minio-mcp: MinIO S3 operations
- notion-mcp: Notion database integration
- filesystem: Local file access

**Data Flow:** LobeChat → Casdoor (auth) → PostgreSQL (data) → MinIO (files) → MCPHub (tools) → vLLM/OpenRouter (inference)

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

1. `cp .env.example .env` and configure secrets (min 32 chars for KEY_VAULTS_SECRET, NEXT_AUTH_SECRET)
2. Set HF_TOKEN for vLLM model downloads
3. Set OPENROUTER_API_KEY for external LLM/embeddings
4. AWS credentials auto-mounted from `~/.aws`

## Port Reference

| Port  | Service        |
|-------|----------------|
| 47000 | LobeChat       |
| 47002 | Casdoor        |
| 47003 | PostgreSQL     |
| 47005 | MinIO API      |
| 47006 | MinIO Console  |
| 47007 | vLLM           |
| 47008 | MCPHub         |
