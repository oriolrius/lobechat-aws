# Agent — Cloud Diagram Assistant

LobeChat agent that renders cloud-architecture diagrams, uploads the PNG to MinIO, and embeds the image inline in chat. Same pattern as the existing **Screenshot Service Agent**, but for diagrams instead of browser captures.

| Field | Value |
|-------|-------|
| Agent ID | `agt_DiagMinio01` |
| Title | **Cloud Diagram Assistant** |
| Model | `claude-sonnet-4-6` (via Meridian / Anthropic provider). Any tool-capable model works. |
| Provider | `anthropic` |
| Plugins | `mcphub-diagrams`, `mcphub-minio`, `mcphub-fs` |
| Temperature / top_p | 0.3 / 0.9 |
| Public bucket | `diagrams` (anonymous `download` policy on `arn:aws:s3:::diagrams/*`) |
| Public URL pattern | `http://wsl.ymbihq.local:47005/diagrams/<objectName>` (with `localhost:47005` as fallback) |

## Why this exists

`mcphub-diagrams` writes PNGs to `/tmp/generated-diagrams/` **inside the mcphub container**. Without a publishing step, LobeChat (running on the host browser) cannot render those files. The agent solves this by uploading each PNG to a public MinIO bucket and replying with a markdown image link that LobeChat fetches over HTTP.

## How it works (same trick as the screenshot agent)

1. **One-time MinIO setup** (idempotent, runs only on the first turn of a conversation):
   - `connect_minio(endPoint=minio, port=9000, accessKey=minioadmin, secretKey=minioadmin, useSSL=false)`
   - `bucket_exists("diagrams")` → if false, `create_bucket("diagrams")`. "Already exists" treated as success.
   - `set_bucket_policy("diagrams", <public read on diagrams/*>)`
2. **Per request — render**:
   - Identify cloud(s) and resources. Optionally call `infrastructure-diagrams-list_icons` to verify icon names. Optionally `parse_terraform` / `parse_helm_chart` / `parse_k8s_manifest` if the user provided IaC.
   - Write a self-contained Python `diagrams` snippet using `with Diagram(..., show=False)` and `Cluster(...)` for groupings.
   - Call `infrastructure-diagrams-generate_diagram` with the snippet. The tool **returns the absolute path** of the PNG it wrote.
3. **Per request — upload + reply**:
   - Build `objectName = <slug>-<unix_ts>.png` (`[a-z0-9-]+`).
   - `upload_file(bucketName="diagrams", objectName=<objectName>, filePath=<EXACT path returned in step 2>)`. **Key constraint**: the model must reuse the path verbatim — same gotcha that bit the screenshot agent ("file not found" if the model invents a path).
   - Compose the public URL: `http://wsl.ymbihq.local:47005/diagrams/<objectName>`.
4. **Reply shape** (mandatory — keeps the rendered image inline in LobeChat):
   ```
   **Diagram: <short title>**

   Image URL: <public-url>

   ![<alt-text>](<public-url>)

   <details><summary>Source (Python `diagrams`)</summary>

   ```python
   <the snippet you sent to generate_diagram>
   ```
   </details>
   ```

Both `mcphub-diagrams` and `mcphub-minio` run inside the same `mcphub` container, so the upload tool reads the local path the diagram tool printed — no `docker cp` needed.

## Sample prompts

- *"Draw a canonical 3-tier AWS web app: ALB → EC2 ASG → RDS Multi-AZ in private subnet."*
- *"Render this Terraform as a diagram (paste / file)."* → triggers `parse_terraform` first.
- *"GKE cluster with three deployments (api, worker, web), CloudSQL for Postgres, Cloud Storage bucket, all inside one VPC."*
- *"Compare on-prem MQTT-to-Kafka vs AWS IoT Core + MSK. Two diagrams side by side."*

## Verifying everything is wired

```bash
# DB row exists
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "SELECT id, title, model, plugins FROM agents WHERE id='agt_DiagMinio01';"

# Bucket is public
docker exec minio mc anonymous get local/diagrams

# Public URL resolves
curl -sI http://wsl.ymbihq.local:47005/diagrams/ | head -1
# → 'HTTP/1.1 200 OK' (or 403/404 for missing object — but the host responds)
```

In LobeChat: pick the **Cloud Diagram Assistant** agent → ask any of the sample prompts → image renders inline, `<details>` block carries the editable Python source.

## Recreating the agent from scratch

If the row is wiped (e.g. DB drop), recreate it with the helper pattern below — keep the system prompt in a file so it survives shell quoting / heredoc traps.

```bash
USER_ID=$(docker exec shared-postgres psql -U postgres -d lobechat -tAc \
  "SELECT user_id FROM user_installed_plugins LIMIT 1;")

# 1. write the system prompt to a file (this repo keeps it inline in this doc)
cp /home/oriol/esade/lobechat-aws/docs/agent-cloud-diagrams.md /tmp/prompt.txt
# (… or extract just the role section into /tmp/prompt.txt)

# 2. create the row, system_role empty
docker exec shared-postgres psql -U postgres -d lobechat <<SQL
INSERT INTO agents (id, user_id, title, description, model, provider,
                    plugins, opening_message, chat_config, params)
VALUES ('agt_DiagMinio01', '$USER_ID',
        'Cloud Diagram Assistant',
        'Renders AWS / GCP / Azure / K8s diagrams via the diagrams package, uploads the PNG to MinIO, and shows it inline.',
        'claude-sonnet-4-6', 'anthropic',
        '["mcphub-diagrams","mcphub-minio","mcphub-fs"]'::jsonb,
        'Tell me what to draw. I render with the Python diagrams package, upload the PNG to MinIO, and embed the image inline.',
        '{"autoCreateTopicThreshold":2,"displayMode":"chat","enableAutoCreateTopic":true,"enableHistoryCount":false,"historyCount":8}'::jsonb,
        '{"temperature":0.3,"top_p":0.9}'::jsonb)
ON CONFLICT (id) DO NOTHING;
SQL

# 3. patch system_role from the file (avoids shell escaping hell)
docker cp /tmp/prompt.txt shared-postgres:/tmp/prompt.txt
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "UPDATE agents SET system_role = pg_read_file('/tmp/prompt.txt') WHERE id='agt_DiagMinio01';"
```

# 4. wire it into the LobeChat sidebar — without this row the agent is invisible
docker exec -i shared-postgres psql -U postgres -d lobechat <<SQL
INSERT INTO sessions (id, slug, title, description, type, user_id)
VALUES ('ssn_DiagMinio01','cloud-diagram-assistant','Cloud Diagram Assistant',
        'Renders cloud diagrams and uploads the PNG to MinIO.',
        'agent', '$USER_ID')
ON CONFLICT (id) DO NOTHING;
INSERT INTO agents_to_sessions (agent_id, session_id, user_id)
VALUES ('agt_DiagMinio01','ssn_DiagMinio01','$USER_ID')
ON CONFLICT (agent_id, session_id) DO NOTHING;
SQL
```

> The LobeChat sidebar lists rows from `sessions` (filtered `type='agent'`) joined to `agents` via `agents_to_sessions`. Inserting an `agents` row alone is not enough — pair it with a `sessions` row and the join.

The bucket + policy can be re-created with:

```bash
docker exec minio mc alias set local http://localhost:9000 minioadmin minioadmin
docker exec minio mc mb -p local/diagrams
docker exec minio mc anonymous set download local/diagrams
```

## Related docs

- [`docs/mcp-diagrams.md`](mcp-diagrams.md) — the MCP server itself: when to use, role-prompt template, troubleshooting.
- [`docs/mcp-onboarding.md`](mcp-onboarding.md) — the generic process for registering any new MCP into both MCPHub and LobeChat.
