# LobeChat Local Stack

Self-hosted LobeChat backed by PostgreSQL + Casdoor SSO + MinIO, plus a local RAG stack (**Qdrant** + **Hayhooks**), local LLM inference (**vLLM** running **Gemma 4 E4B** with native function calling), and an **MCPHub** aggregator that exposes ~10 MCP servers (ssh-exec, notion, qdrant, haystack, infrastructure-diagrams, d2, playwright, filesystem, minio, aws-*) to any chat agent.

## Quick Start

```bash
docker compose up -d
```

## Architecture

See [docs/architecture.drawio](docs/architecture.drawio) for visual diagram.

```
User --> LobeChat (:47000)
              |
              +--> Casdoor (:47002)  --> PostgreSQL (casdoor db)
              |
              +--> MinIO (:47005)    --> ./data/minio
              |
              +--> PostgreSQL        --> ./data/postgres
              |    (lobechat db)
              |
              +--> MCPHub (:47008) --> {ssh-exec, notion, qdrant, haystack, ...}
              |
              +--> vLLM (:47007)   --> Gemma 4 E4B (local, function calling)
              |
              +--> Qdrant (:47010) --> ./data/qdrant   (vector DB)
              |
              +--> Hayhooks (:47012)        --> Haystack pipelines REST
                   Hayhooks MCP (:47013)    --> Haystack pipelines as MCP
```

## Services

| Service | Container | Port | Description |
|---------|-----------|------|-------------|
| LobeChat | lobe-chat | 47000 | Main application |
| Casdoor | casdoor | 47002 | SSO authentication |
| MinIO S3 | minio | 47005 | Object storage API |
| MinIO Console | minio | 47006 | Storage admin UI |
| vLLM | vllm | 47007 | Local LLM (gemma-4-E4B-it, MCP tool calling) |
| MCPHub | mcphub | 47008 | MCP server hub |
| Qdrant REST | qdrant | 47010 | Vector DB HTTP API |
| Qdrant gRPC | qdrant | 47011 | Vector DB gRPC |
| Hayhooks | hayhooks | 47012 | Haystack pipelines REST |
| Hayhooks MCP | hayhooks-mcp | 47013 | Haystack as MCP server |
| PostgreSQL | shared-postgres | 47003 | Database |

## Access

| Service | URL |
|---------|-----|
| LobeChat | http://localhost:47000 |
| Casdoor Admin | http://localhost:47002 |
| MinIO Console | http://localhost:47006 |
| vLLM API | http://localhost:47007/v1 |
| MCPHub | http://localhost:47008 |
| Qdrant Dashboard | http://localhost:47010/dashboard |
| Hayhooks API | http://localhost:47012 |
| Hayhooks Swagger | http://localhost:47012/docs |
| Hayhooks ReDoc | http://localhost:47012/redoc |
| Hayhooks MCP | http://localhost:47013/mcp |

## Credentials

| Service | Username | Password |
|---------|----------|----------|
| LobeChat | user | pswd123 |
| Casdoor Admin | admin | pswd123 |
| MinIO | minioadmin | minioadmin |
| MCPHub | admin | admin123 |
| PostgreSQL | postgres | postgres |
| vLLM | API key: `sk-local` (no username) | |
| Qdrant | none (open on local network) | |
| Hayhooks | none (open on local network) | |

vLLM model (OpenAI-compatible, API key `sk-local`):
- `google/gemma-4-E4B-it` at `http://localhost:47007/v1` (Gemma 4, native function calling for MCP)

## Commands

```bash
docker compose up -d          # Start
docker compose down           # Stop
docker compose logs -f        # All logs
docker compose logs -f lobe-chat  # LobeChat logs
docker compose restart lobe-chat  # Restart service
```

## Project Structure

```
.
├── docker-compose.yml         # Stack definition
├── .env                       # Environment variables (gitignored)
├── dockerfiles/
│   └── mcphub.Dockerfile      # mcphub image extended with graphviz, docker.io, gcc
├── config/
│   ├── casdoor-app.conf       # Casdoor server config
│   ├── init_data.json         # Casdoor initial data
│   ├── init-postgres.sql      # Database init script
│   ├── mcp_settings.json      # MCPHub server registry (source of truth)
│   ├── mcp_settings.json.bak  # Backup
│   └── ssh/                   # mcphub SSH key for ssh-exec MCP (gitignored)
├── db/
│   ├── migrate                # dbmate wrapper script
│   ├── migrations/            # Incremental SQL migrations
│   ├── schema.sql             # Schema snapshot
│   └── seed.sql               # Seed data
├── patches/
│   └── route.js               # LobeChat hotfix for MCP session retry logic
├── data/                      # gitignored
│   ├── postgres/              # PostgreSQL data
│   ├── minio/                 # Uploaded files
│   ├── qdrant/                # Qdrant vector storage
│   ├── huggingface/           # vLLM model cache
│   └── mcphub/                # MCPHub runtime data
└── docs/
    ├── architecture.drawio    # Architecture diagram
    ├── rag-demo/              # Haystack + Qdrant RAG use case
    ├── mcp-onboarding.md      # How to register a new MCP server
    ├── mcp-d2.md              # Agent guide: d2 MCP
    ├── mcp-diagrams.md        # Agent guide: infrastructure-diagrams MCP
    ├── lobechat-assistants.md # How to seed LobeChat agents from outside the UI
    ├── agent-cloud-diagrams.md# Cloud Diagram Assistant agent
    └── agent-rag-sage.md      # RAG Sage agent
```

## Adding new MCP servers

End-to-end process for registering a new MCP in MCPHub and exposing it to LobeChat: see [`docs/mcp-onboarding.md`](docs/mcp-onboarding.md).

Per-server agent guides (when to use, role prompt, sample prompts):
- [`docs/mcp-d2.md`](docs/mcp-d2.md) — D2 diagram language (logical / abstract diagrams)
- [`docs/mcp-diagrams.md`](docs/mcp-diagrams.md) — `diagrams` + Graphviz (cloud topology w/ vendor icons)

Pre-built LobeChat agents:
- [`docs/agent-cloud-diagrams.md`](docs/agent-cloud-diagrams.md) — Cloud Diagram Assistant 🏗️ (renders + uploads PNG to MinIO + embeds inline)
- [`docs/agent-rag-sage.md`](docs/agent-rag-sage.md) — RAG Sage 📚 (dynamic-discovery RAG over the local corpus, returns markdown artifact)

How to create / update / delete LobeChat agents from outside the UI (DB recipe used by the entries above):
- [`docs/lobechat-assistants.md`](docs/lobechat-assistants.md)

## Configuration

Edit `.env` for:
- `KEY_VAULTS_SECRET`, `NEXT_AUTH_SECRET` — LobeChat secrets, min 32 chars (base64 for `KEY_VAULTS_SECRET`)
- `AUTH_CASDOOR_*` — SSO settings (id + secret match `config/init_data.json`)
- `POSTGRES_PASSWORD` — shared Postgres password
- `S3_*`, `MINIO_ROOT_USER`, `MINIO_ROOT_PASSWORD` — MinIO storage
- `HF_TOKEN` — Hugging Face token, used by vLLM to fetch gated Gemma 4 weights
- `OPENROUTER_API_KEY` — external LLM + embedding provider (also used as `OPENAI_API_KEY` for embeddings)
- `OPENAPI_MCP_HEADERS` — Notion bearer token for `notion-mcp`. Format: `{"Authorization":"Bearer ntn_…","Notion-Version":"2022-06-28"}`
- `VLLM_MODEL_ID` — defaults to `google/gemma-4-E4B-it`
- `MCPHUB_ADMIN_USER`, `MCPHUB_ADMIN_PASSWORD` — MCPHub admin login
- `SSH_HOST`, `SSH_USERNAME`, `SSH_ALLOWED_COMMANDS`, … — `ssh-exec` MCP whitelist
- AWS credentials are auto-mounted from `~/.aws` into `mcphub` (no `.env` entry needed)

Anthropic models (`claude-sonnet-4-6`, `claude-opus-4-7`, …) are wired via the [Meridian](https://github.com/rynfar/meridian) bridge running outside this compose stack. The provider is registered directly in the `ai_providers` Postgres table (encrypted `key_vaults` blob via `KEY_VAULTS_SECRET`); see `docs/lobechat-assistants.md` for the encryption recipe.
