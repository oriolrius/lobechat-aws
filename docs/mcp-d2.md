# MCP `d2` — D2 diagram language

Server: [`h0rv/d2-mcp`](https://github.com/h0rv/d2-mcp) wrapping the [D2 diagram scripting language](https://d2lang.com).
Plugin id in LobeChat: `mcphub-d2`. Plugin URL: `http://mcphub:3000/mcp/d2`.

## What it does

Three MCP tools:

| Tool | Purpose |
|------|---------|
| `d2-compile-d2` | Validate / compile D2 source. Returns parse errors and the canonicalized D2 string. |
| `d2-render-d2` | Render D2 source to SVG (this stack is configured with `--image-type svg`; ASCII is also fine). Returns the rendered diagram inline. |
| `d2-fetch_d2_cheat_sheet` | Returns the official D2 syntax cheat sheet so the model can author correct D2 without prior training. |

Transport: **stdio**, container-in-container — `mcphub` spawns `docker run --rm -i ghcr.io/h0rv/d2-mcp:main --image-type svg`. The `mcphub` image has `docker.io` and the host docker socket mounted (`/var/run/docker.sock`), so each invocation pulls a fresh ephemeral container.

## When to use it

Pick `d2` when the user asks for:
- **Software architecture** — services, databases, queues, network boundaries; D2's container/group syntax is great for this.
- **Sequence / flow diagrams** between named actors.
- **Class / ER diagrams** — D2 has shape language for these.
- **Any "draw me X"** request where the user wants editable, version-controllable source — D2 is plain text, easy to diff.

Prefer `d2` over `infrastructure-diagrams` (`mcphub-diagrams`) when:
- The diagram is **abstract / logical** (services, flows, states) rather than vendor-specific cloud topology.
- The user wants the **source** of the diagram, not just an image, so they can iterate.
- The model needs to render multiple variants quickly (D2 source is shorter than `diagrams` Python).

Prefer `infrastructure-diagrams` (Graphviz + cloud icon packs) when:
- The diagram is **vendor-specific cloud infra** (AWS / GCP / Azure / K8s) and the user expects the official icons.
- Input is **Terraform / Helm / K8s YAML** and you want the parser tools.

If you hesitate, ask the user. If they answer "I want both", call `render-d2` for the logical view and `infrastructure-diagrams.generate_diagram` for the cloud view in the same answer.

## LobeChat agent setup

| Field | Value |
|-------|-------|
| **Plugins** | toggle ON: `mcphub-d2`. Optionally also `mcphub-diagrams` and `mcphub-qdrant`. |
| **Model** | any with function calling (`google/gemma-4-E4B-it` via local vLLM, or external Anthropic / OpenAI / OpenRouter model). |
| **Tool choice** | `auto`. |
| **Temperature** | 0.3 — diagrams want low variance. |

### Role / system prompt

```
You are a software architecture assistant. When the user asks for a diagram or
when explaining a design would benefit from one, you MUST use the `mcphub-d2`
plugin instead of describing the diagram in prose only.

Workflow:
1. Read the request carefully and identify entities, relationships, and
   grouping (services, databases, message buses, network boundaries).
2. If you are unsure of D2 syntax for a specific construct, call
   `d2-fetch_d2_cheat_sheet` first.
3. Draft the D2 source. Validate it with `d2-compile-d2` and fix any reported
   error before continuing.
4. Render with `d2-render-d2` and include the resulting SVG in the answer.
5. Always also include the D2 source in a fenced ```d2 block so the user can
   edit and re-render later.
6. Keep diagrams small and focused — one concept per diagram. If the user
   asks for several views, render them one by one with separate render calls.

Style:
- Prefer container syntax (`group: {...}`) for logical boundaries.
- Use connection labels for protocols / verbs (e.g. `web -> db: SQL`).
- Default to top-down layout unless the user asks for left-to-right.
- For sequences, use D2's sequence diagram shape.

When NOT to use d2:
- The user explicitly wants AWS/GCP/Azure/K8s vendor icons → switch to
  `mcphub-diagrams.generate_diagram` instead.
- The user asks for a chart of numerical data → that is not a diagram task,
  decline politely and answer in prose or as a markdown table.
```

### Sample prompts that exercise the plugin

1. "Draw the architecture of this stack: LobeChat, Casdoor, Postgres, MinIO, Qdrant, Hayhooks, MCPHub, vLLM. Group inference and storage separately."
2. "Sketch the OAuth2 authorization-code flow between user, browser, Casdoor, and a backend."
3. "Compare two approaches for indexing documents into Qdrant: Haystack-only vs Haystack+fastembed. Render both as side-by-side D2 diagrams."

## Smoke test

```bash
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)

curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers \
  | jq '.data[] | select(.name=="d2") | {status, tools:(.tools|length)}'
```

Expected: `status: "connected"`, `tools: 3`.

## Onboarding back-reference

Server registered following [`docs/mcp-onboarding.md`](mcp-onboarding.md):

- MCPHub config block (`config/mcp_settings.json`):
  ```json
  "d2": {
    "enabled": true, "owner": "admin", "type": "stdio",
    "command": "docker",
    "args": ["run", "--rm", "-i",
             "ghcr.io/h0rv/d2-mcp:main",
             "--image-type", "svg"],
    "env": {}
  }
  ```
- System dep added in `dockerfiles/mcphub.Dockerfile`: `docker.io` (so mcphub can spawn `docker run`).
- LobeChat plugin row inserted via the helper in the onboarding doc, with `LC_IDENT=mcphub-d2`, `MCP_NAME=d2`.
