# MCP `infrastructure-diagrams` — cloud infra topology

Server: [`andrewmoshu/diagram-mcp-server`](https://github.com/andrewmoshu/diagram-mcp-server) (PyPI: `infrastructure-diagram-mcp-server`).
Backend: Python `diagrams` package + Graphviz.
Plugin id in LobeChat: `mcphub-diagrams`. Plugin URL: `http://mcphub:3000/mcp/infrastructure-diagrams`.

## What it does

Six MCP tools:

| Tool | Purpose |
|------|---------|
| `infrastructure-diagrams-generate_diagram` | Execute Python `diagrams` code → PNG. Has access to **2000+ icons** for AWS, GCP, Azure, Kubernetes, on-prem, generic shapes. |
| `infrastructure-diagrams-get_diagram_examples` | Returns ready-to-use example code per diagram type (AWS web app, K8s cluster, ETL, etc.). Use first when the model is unsure of the API surface. |
| `infrastructure-diagrams-list_icons` | Browse / filter the icon catalog. Useful when the user asks for a specific service that the model is not certain exists in the package. |
| `infrastructure-diagrams-parse_k8s_manifest` | Parse a YAML manifest → structured resource model that can be passed straight into a diagram. |
| `infrastructure-diagrams-parse_helm_chart` | Same idea for Helm charts (template + render). |
| `infrastructure-diagrams-parse_terraform` | Parse Terraform HCL → resources + relationships, ready to draw. |

Transport: **stdio**. `mcphub` spawns `uvx infrastructure-diagram-mcp-server`. The `mcphub` image ships with `graphviz`, `libgraphviz-dev`, and `gcc` — all installed via `dockerfiles/mcphub.Dockerfile` so `pygraphviz` builds inside the venv `uvx` creates.

## When to use it

Pick `infrastructure-diagrams` when the user wants:
- A **vendor-branded** cloud topology — AWS LB → EC2 → RDS, GCP Pub/Sub → Cloud Run → BigQuery, Azure equivalents, K8s with proper icons.
- A diagram **derived from existing IaC** (Terraform, Helm, raw K8s YAML). The parser tools turn the model into a "draw what I have" assistant rather than a "draw what you imagine" one.
- A polished PNG to drop into a slide deck or doc.

Prefer `d2` (`mcphub-d2`) when:
- The diagram is **abstract / logical** (no vendor icons needed).
- The user wants the **source** of the diagram to live in version control and iterate quickly.
- The diagram is small and rendering speed matters.

Don't use either if:
- The user wants a chart of numerical data — that's a plotting task, not a diagram task.

## LobeChat agent setup

| Field | Value |
|-------|-------|
| **Plugins** | toggle ON: `mcphub-diagrams`. Often paired with `mcphub-aws-docs` for citation, and `mcphub-fs` if you want the model to read a Terraform file off disk. |
| **Model** | any with function calling. The Python code blocks the model writes for `generate_diagram` are non-trivial — bigger models (gemma-4-E4B and up, GPT-4 class, Claude Sonnet) handle this much better than tiny models. |
| **Tool choice** | `auto`. |
| **Temperature** | 0.3. |

### Role / system prompt

```
You are an infrastructure architect. When the user asks for a cloud topology
or asks to "draw" / "diagram" a system, you MUST use the `mcphub-diagrams`
plugin (Python `diagrams` package over Graphviz).

Workflow:
1. Identify the cloud(s) involved (AWS / GCP / Azure / K8s / on-prem).
2. If unsure which icons exist for the requested services, call
   `infrastructure-diagrams-list_icons` filtered by provider before writing
   code.
3. If the user provided IaC (Terraform / Helm / K8s YAML), call the matching
   `parse_*` tool first and use its output as the source of truth — do not
   make up resources that the parser did not return.
4. If you need an example, call `get_diagram_examples` once.
5. Write a self-contained Python snippet using the `diagrams` package and
   call `generate_diagram` with it. Use `with Diagram(...)` so the PNG is
   produced. Use `Cluster(...)` for logical groupings (VPC, subnet, account,
   namespace).
6. Always include the Python source in a fenced ```python block in your
   answer, after the rendered image.
7. Keep diagrams readable: max ~15 nodes per diagram, use sub-clusters,
   avoid crossing edges.

When NOT to use this plugin:
- Logical / abstract diagrams without vendor icons → use `mcphub-d2` instead.
- The user only asked for an explanation, not a picture → answer in prose.
```

### Sample prompts that exercise the plugin

1. "Diagram the canonical AWS three-tier web app: ALB, two EC2 web servers in an Auto Scaling Group, RDS Multi-AZ in a private subnet."
2. "Here is my `main.tf` — *(paste / file)* — render it as an architecture diagram."
3. "Draw a GKE cluster with three deployments (api, worker, web), a PostgreSQL CloudSQL instance, and a Cloud Storage bucket for media. Group everything inside a VPC."
4. "Compare on-prem MQTT-to-Kafka pipeline vs the same workload on AWS IoT Core + MSK. Two diagrams side by side."

## Smoke test

```bash
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)

curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers \
  | jq '.data[] | select(.name=="infrastructure-diagrams") | {status, tools:(.tools|length)}'
```

Expected: `status: "connected"`, `tools: 6`.

## Onboarding back-reference

Server registered following [`docs/mcp-onboarding.md`](mcp-onboarding.md):

- MCPHub config block (`config/mcp_settings.json`):
  ```json
  "infrastructure-diagrams": {
    "enabled": true, "owner": "admin", "type": "stdio",
    "command": "uvx",
    "args": ["infrastructure-diagram-mcp-server"],
    "env": { "FASTMCP_LOG_LEVEL": "ERROR" }
  }
  ```
- System deps added in `dockerfiles/mcphub.Dockerfile`: `graphviz libgraphviz-dev gcc` (so `pygraphviz` compiles inside the `uvx` venv).
- LobeChat plugin row inserted via the helper in the onboarding doc, with `LC_IDENT=mcphub-diagrams`, `MCP_NAME=infrastructure-diagrams`.
