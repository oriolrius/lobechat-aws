# Creating LobeChat assistants from outside the UI

This is the recipe used to seed the project's pre-built agents (Cloud Diagram Assistant, RAG Sage, Screenshot Service, …). You drop a few rows into the `lobechat` Postgres database and the agent appears in the LobeChat sidebar without a restart and without using the UI's "Create Agent" wizard.

## Why bypass the UI

- Reproducibility — version-control the system prompt as a real file.
- Avoid the UI's frequent re-rendering / topic-creation churn while iterating on a complex role.
- Easy to wire MCP plugins that already live in `mcphub` — no copy-paste of plugin URLs.

## Tables involved

LobeChat's sidebar lists rows from `sessions` (filtered `type='agent'`) joined to `agents` via `agents_to_sessions`. Three rows are needed:

| Table | Purpose |
|-------|---------|
| `agents` | Agent definition: title, model/provider, plugins, **system_role**, chat config. |
| `sessions` | The sidebar entry the user clicks. Cosmetic title / avatar / background. Without this row the agent is **invisible**. |
| `agents_to_sessions` | M:N link. Required so the session loads the agent's settings. |

Optionally:

| Table | When |
|-------|------|
| `ai_providers`, `ai_models` | Only if you are using a custom provider / model not yet enabled (e.g. wiring Meridian / Anthropic for the first time). |
| `user_installed_plugins` | Only if the plugins you reference in `agents.plugins` are not yet installed for the user — see [`mcp-onboarding.md`](mcp-onboarding.md). |

## Recipe

The four steps below — keep them in this order.

### 1. Write the system prompt to a file

```bash
cat > /tmp/agent_prompt.txt <<'PROMPT'
You are <role>…
…
PROMPT
```

Keep it in a file because shell + heredoc + SQL escaping breaks any prompt longer than ~50 lines. The patch step below uses `pg_read_file` to load it verbatim.

### 2. Insert the `agents` row (system_role left empty for now)

```bash
USER_ID=$(docker exec shared-postgres psql -U postgres -d lobechat -tAc \
  "SELECT user_id FROM user_installed_plugins LIMIT 1;")

AGENT_ID=agt_<UniqueShortId>          # e.g. agt_RagSage01
SESSION_ID=ssn_<UniqueShortId>         # match the agent id for sanity

docker exec -i shared-postgres psql -U postgres -d lobechat <<SQL
INSERT INTO agents (id, user_id, title, description, model, provider,
                    plugins, opening_message, avatar, background_color,
                    chat_config, params)
VALUES ('$AGENT_ID','$USER_ID',
        '<Title shown in sidebar>',
        '<One-line description>',
        'claude-sonnet-4-6','anthropic',          -- pick a tool-capable model
        '["mcphub-qdrant","lobe-artifacts"]'::jsonb,  -- plugins to enable on this agent
        '<Greeting shown when opening the chat>',
        '📚','#3b2a1a',                            -- avatar emoji + background
        '{"autoCreateTopicThreshold":2,"displayMode":"chat","enableAutoCreateTopic":true,"enableHistoryCount":false,"historyCount":12}'::jsonb,
        '{"temperature":0.2,"top_p":0.9}'::jsonb)
ON CONFLICT (id) DO NOTHING;
SQL
```

### 3. Patch `system_role` from the file

```bash
docker cp /tmp/agent_prompt.txt shared-postgres:/tmp/agent_prompt.txt
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "UPDATE agents SET system_role = pg_read_file('/tmp/agent_prompt.txt') WHERE id='$AGENT_ID';"
```

`pg_read_file` runs server-side, so no shell quoting issues regardless of prompt length.

### 4. Make it appear in the sidebar (`sessions` + link)

```bash
docker exec -i shared-postgres psql -U postgres -d lobechat <<SQL
INSERT INTO sessions (id, slug, title, description, type, user_id, avatar, background_color)
VALUES ('$SESSION_ID','<url-slug>','<Title>',
        '<Description>',
        'agent','$USER_ID','📚','#3b2a1a')
ON CONFLICT (id) DO NOTHING;
INSERT INTO agents_to_sessions (agent_id, session_id, user_id)
VALUES ('$AGENT_ID','$SESSION_ID','$USER_ID')
ON CONFLICT (agent_id, session_id) DO NOTHING;
SQL
```

Refresh LobeChat — the new agent is in the sidebar. No restart.

## Picking model, plugins, params

| Decision | Rule of thumb |
|----------|---------------|
| Model | Anything tool-capable. Project defaults: `claude-sonnet-4-6` via Meridian (long-context, free under Max), `google/gemma-4-E4B-it` via local vLLM (offline), or any OpenRouter model. Tiny models (gemma-3-270m) are fine only for non-tool agents. |
| Provider | Must match the `id` of the row in `ai_providers` for the user. `anthropic`, `openrouter`, `google`, `vllm` are the ones currently enabled. |
| Plugins | Use the `identifier` from `user_installed_plugins`. To list: `SELECT identifier FROM user_installed_plugins;`. Each plugin is per-agent — toggle conservatively. |
| Avatar | Single emoji that matches the agent's purpose. Use `background_color` as a complementary hex (kept on both `agents` and `sessions` rows so the look stays consistent). |
| Temperature | 0.2–0.3 for factual / tool-driven agents, 0.7+ for creative agents. |

## Updating an existing agent

```bash
# update system_role
echo "new prompt" > /tmp/p.txt
docker cp /tmp/p.txt shared-postgres:/tmp/p.txt
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "UPDATE agents SET system_role = pg_read_file('/tmp/p.txt') WHERE id='agt_…';"

# update plugins
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "UPDATE agents SET plugins='[\"mcphub-qdrant\",\"lobe-artifacts\"]'::jsonb WHERE id='agt_…';"

# change avatar / color (also update sessions row to keep sidebar consistent)
docker exec -i shared-postgres psql -U postgres -d lobechat <<SQL
UPDATE agents   SET avatar='🧠', background_color='#1e3a5f' WHERE id='agt_…';
UPDATE sessions SET avatar='🧠', background_color='#1e3a5f' WHERE id='ssn_…';
SQL
```

LobeChat re-reads the agent on the next message — no restart required.

## Deleting an agent

```bash
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "DELETE FROM agents WHERE id='agt_…';"   -- agents_to_sessions cascades
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "DELETE FROM sessions WHERE id='ssn_…';"
```

## Pre-built agents in this repo

| ID | Title | Plugins | Doc |
|----|-------|---------|-----|
| `agt_DiagMinio01` | Cloud Diagram Assistant 🏗️ | `mcphub-diagrams`, `mcphub-minio`, `mcphub-fs` | [`agent-cloud-diagrams.md`](agent-cloud-diagrams.md) |
| `agt_RagSage01`   | RAG Sage 📚 | `mcphub-qdrant`, `lobe-artifacts` | [`agent-rag-sage.md`](agent-rag-sage.md) |
| `agt_R7R98pk05OJq` | Screenshot Service Agent | `mcphub-minio`, `mcphub-fs`, `mcphub-playwright` | (community pattern, see Cloud Diagram doc for the same trick) |

## Related docs

- [`mcp-onboarding.md`](mcp-onboarding.md) — registering new MCP servers in MCPHub + LobeChat (must be done before they can be referenced in `agents.plugins`).
- Per-MCP guides: [`mcp-d2.md`](mcp-d2.md), [`mcp-diagrams.md`](mcp-diagrams.md).
