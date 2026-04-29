# MCP onboarding — register a new MCP server end-to-end

This guide is the contract for adding a new MCP (Model Context Protocol) server to this stack so it is reachable both **as a tool from LobeChat** and **as a tool from any external MCP client** that talks to MCPHub.

There are two layers, and **both** must be touched:

```
┌──────────────────┐   /api/auth/login      ┌────────────────┐    spawn
│  LobeChat plugin │  ────────────────────► │     MCPHub     │ ─────────► your MCP server
│  (customPlugin)  │  GET /mcp/<server>     │  47008         │ stdio | streamable-http
└──────────────────┘                        └────────────────┘
   user_installed_plugins (Postgres)         config/mcp_settings.json
```

| Layer | Where | What it stores |
|-------|-------|----------------|
| **MCPHub** | `config/mcp_settings.json` | how to spawn / connect to the MCP server (stdio command + env, or remote streamable-http URL) |
| **LobeChat** | Postgres table `user_installed_plugins` (db `lobechat`) | a `customPlugin` row whose `custom_params.mcp.url` points back at MCPHub's per-server endpoint |

## 1. Pick a transport

| Transport | When | `mcp_settings.json` shape |
|-----------|------|----------------------------|
| `stdio` | The MCP server is a CLI binary (`uvx …`, `npx …`, `python -m …`, custom script). Most third-party servers use this. | `{"type":"stdio","command":"…","args":[…],"env":{…}}` |
| `streamable-http` | The MCP server is already a long-running HTTP service exposing `/mcp` (e.g. a sidecar container). | `{"type":"streamable-http","url":"http://<container>:<port>/mcp"}` |

If the MCP server is `stdio` and depends on system binaries (Graphviz, ffmpeg, sqlite, …) those binaries must be present **inside the mcphub container**. The provided `dockerfiles/mcphub.Dockerfile` is the place to install them — extend it instead of mutating the running container.

## 2. Register the server in MCPHub (`config/mcp_settings.json`)

Add a new entry under `mcpServers` with a unique key. Pattern:

```jsonc
{
  "mcpServers": {
    "<server-key>": {
      "enabled": true,
      "owner": "admin",
      "type": "stdio",                    // or "streamable-http"
      "command": "uvx",                    // omit for streamable-http
      "args": ["package-name", "--flag"],  // omit for streamable-http
      "url": "http://svc:1417/mcp",        // for streamable-http only
      "env": {
        "MY_TOKEN": "${MY_TOKEN}"          // pulled from compose env at runtime
      }
    }
  }
}
```

Conventions used in this repo:

- Use `${ENV}` interpolation in the `env` block; declare the same variable in `.env` and pass it through in `docker-compose.yml` under `mcphub.environment`.
- For tools that need a token, load it from Bitwarden once and write to `.env` — never inline secrets in `mcp_settings.json`.
- Prefer `uvx` for Python MCP servers and `npx -y` for Node ones — both auto-fetch on first run and cache locally inside the container.

After editing, recreate `mcphub` so the new entry is picked up:

```bash
docker compose down mcphub
docker compose up -d mcphub
```

(For Dockerfile changes, run `docker compose build mcphub` first.)

Verify the server connected and discovered its tools:

```bash
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)

curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers \
  | jq '.data[] | select(.name=="<server-key>") | {status, tools: (.tools|length), error}'
```

Expected: `status: "connected"`, `tools >= 1`, `error: null`.

## 3. Register the same server in LobeChat (`user_installed_plugins`)

LobeChat keeps installed plugins in Postgres. The shared MCPHub endpoint pattern is:

```
http://mcphub:3000/mcp/<server-key>
```

Drop a `customPlugin` row whose `custom_params.mcp.url` points there. Use the helper below — it pulls the freshly discovered tool list from MCPHub and bakes it into the manifest so LobeChat shows the tools immediately, without a "Reinstall" click.

```bash
# 1. fetch live server metadata (tools + descriptions)
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)
curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers -o /tmp/srv.json

# 2. discover the LobeChat user_id (any user works; usually the only one)
USER_ID=$(docker exec shared-postgres psql -U postgres -d lobechat -tAc \
  "SELECT user_id FROM user_installed_plugins LIMIT 1;")

# 3. build INSERT for one MCPHub server -> LobeChat customPlugin
MCP_NAME=<server-key>          # the key from mcp_settings.json
LC_IDENT=mcphub-<short-name>   # plugin id shown in LobeChat

python3 - <<PY > /tmp/insert.sql
import json, os
servers = json.load(open('/tmp/srv.json'))['data']
mcp_name = "$MCP_NAME"
lc_ident = "$LC_IDENT"
user_id  = "$USER_ID"
for s in servers:
    if s['name'] != mcp_name: continue
    api = [{"name":t['name'],"description":t.get('description',''),
            "parameters":t.get('inputSchema',{"type":"object","properties":{}})}
           for t in s['tools']]
    manifest = {
      "identifier": lc_ident, "type": "mcp",
      "meta": {"title": lc_ident, "avatar": "MCP_AVATAR",
               "description": f"{lc_ident} MCP server has {len(api)} tools"},
      "api": api,
    }
    custom = {"mcp":{"url":f"http://mcphub:3000/mcp/{mcp_name}",
                     "auth":{"type":"none"},"type":"http"}}
    print(f"INSERT INTO user_installed_plugins"
          f" (user_id, identifier, type, manifest, custom_params)"
          f" VALUES ('{user_id}','{lc_ident}','customPlugin',"
          f"'{json.dumps(manifest).replace(chr(39),chr(39)*2)}'::jsonb,"
          f"'{json.dumps(custom).replace(chr(39),chr(39)*2)}'::jsonb)"
          f" ON CONFLICT DO NOTHING;")
PY

# 4. apply
docker exec -i shared-postgres psql -U postgres -d lobechat < /tmp/insert.sql
```

Verify:

```sql
docker exec shared-postgres psql -U postgres -d lobechat -c \
  "SELECT identifier, custom_params->'mcp'->>'url' FROM user_installed_plugins ORDER BY identifier;"
```

The new plugin appears in LobeChat's UI under **Plugins** without a refresh — toggle it on inside the agent that should use it.

## 4. Wire the plugin into an agent

Inside LobeChat:
1. Open the target agent → **Plugins** tab.
2. Toggle the new plugin **on** (the toggle is per agent, not global).
3. Make sure the agent's model supports function calling (`google/gemma-4-E4B-it` via local vLLM, or any tool-capable Anthropic / OpenAI / OpenRouter model).
4. Set tool choice to **auto** so the model decides when to invoke tools.
5. Tighten the system prompt: tell the model when to use the plugin, what evidence/citation rules apply, and what to do when the plugin returns nothing.

## 5. Sanity check end-to-end

```bash
# fire a tools/call against the brand-new server through the MCPHub aggregate
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)

curl -sN -X POST http://localhost:47008/mcp \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json, text/event-stream' \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize",
       "params":{"protocolVersion":"2024-11-05","capabilities":{},
                 "clientInfo":{"name":"smoke","version":"1"}}}' \
  -D /tmp/h.txt -o /dev/null
SID=$(grep -i mcp-session-id /tmp/h.txt | awk '{print $2}' | tr -d '\r')

curl -s -X POST http://localhost:47008/mcp \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json, text/event-stream' \
  -H 'Content-Type: application/json' \
  -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' -o /dev/null

curl -sN -X POST http://localhost:47008/mcp \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json, text/event-stream' \
  -H 'Content-Type: application/json' \
  -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | head -c 500
```

If `tools/list` returns the new server's tools, the chain is live. If LobeChat still shows zero tools next to the plugin, refresh the page (LobeChat caches `manifest.api` per session).

## 6. Troubleshooting

| Symptom | Fix |
|---------|-----|
| `mcphub` logs `ERR ModuleNotFoundError` | Tool's runtime dep missing. Add `pip install …` extras to `mcp_settings.json` `args` (not recommended) or extend `dockerfiles/mcphub.Dockerfile`. |
| `dot: not found` / `pygraphviz build failed` | Add `graphviz libgraphviz-dev gcc` to `dockerfiles/mcphub.Dockerfile`. |
| `Wrong input: Not existing vector name error: <name>` from `qdrant-find` | Collection schema mismatch with `mcp-server-qdrant`. Re-index using `fastembed` and write to the named vector slot — see `docs/rag-demo/index_docs_fastembed.py` for the reference pattern. |
| `Failed to connect: TypeError: fetch failed` for streamable-http server | Wrong container hostname/port. Use the compose service name (e.g. `hayhooks-mcp`), not `localhost`, since the call originates from inside the `mcphub` container. |
| Plugin shows up in LobeChat but tool calls do nothing | The agent's model lacks function calling. Switch model or check the LobeChat session log. |
| New server appears as `disconnected` after restart | `docker compose restart mcphub` does not always reload `mcp_settings.json`. Use `docker compose down mcphub && docker compose up -d mcphub`. |

## 7. Repo layout that this process touches

```
.
├── .env                              # secrets and per-server env vars
├── docker-compose.yml                # mcphub service definition (build: dockerfiles/mcphub.Dockerfile)
├── dockerfiles/
│   └── mcphub.Dockerfile             # extend with system deps (graphviz, ffmpeg, …)
├── config/
│   └── mcp_settings.json             # MCPHub server registry (this file is the source of truth for MCPHub)
└── docs/
    └── mcp-onboarding.md             # this guide
```

## Worked example — `infrastructure-diagrams`

1. **Dependency:** Graphviz + dev headers — added to `dockerfiles/mcphub.Dockerfile` (`graphviz libgraphviz-dev gcc`).
2. **MCPHub entry** in `config/mcp_settings.json`:
   ```json
   "infrastructure-diagrams": {
     "enabled": true,
     "owner": "admin",
     "type": "stdio",
     "command": "uvx",
     "args": ["infrastructure-diagram-mcp-server"],
     "env": {"FASTMCP_LOG_LEVEL": "ERROR"}
   }
   ```
3. **Build + restart:** `docker compose build mcphub && docker compose down mcphub && docker compose up -d mcphub`.
4. **Verify:** `infrastructure-diagrams` shows `connected`, **6 tools** (`generate_diagram`, `parse_terraform`, …).
5. **LobeChat row:** insert with `LC_IDENT=mcphub-diagrams`, `MCP_NAME=infrastructure-diagrams` → URL `http://mcphub:3000/mcp/infrastructure-diagrams`.
6. **Use:** toggle `mcphub-diagrams` on in any tool-capable agent → the model can call `generate_diagram` to draw AWS/GCP/K8s topologies inline.
