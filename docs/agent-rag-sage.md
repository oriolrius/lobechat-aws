# Agent — RAG Sage 📚

LobeChat agent that answers questions about RAG (and adjacent topics) by searching the local Qdrant `rag-demo` corpus through MCP, and renders the final answer as a **markdown artifact** so LobeChat opens it in the side panel.

| Field | Value |
|-------|-------|
| Agent ID | `agt_RagSage01` |
| Session ID | `ssn_RagSage01` |
| Title | **RAG Sage** |
| Avatar | `📚` (background `#3b2a1a`) |
| Model | `claude-sonnet-4-6` via Meridian (Anthropic provider) |
| Plugins | `mcphub-qdrant`, `lobe-artifacts` |
| Temperature / top_p | 0.2 / 0.9 |
| Corpus | Qdrant collection `rag-demo`. **The agent discovers its content dynamically** via `qdrant-find` probes — file inventory is NOT baked into the system prompt, so adding / removing documents requires no agent change. See [`docs/rag-demo/README.md`](rag-demo/README.md) for the indexing pipeline. |

## Why this exists

Past RAG chats showed two problems worth fixing in a dedicated agent:

1. **Schema mismatch silently failed.** Early chats hit `"Wrong input: Not existing vector name error: fast-all-minilm-l6-v2"` because the corpus had been indexed via Haystack's default unnamed-vector schema while `mcp-server-qdrant` queries a named vector. This is now fixed at index time (`docs/rag-demo/index_docs_fastembed.py`), but the agent's system prompt is explicit about which collection / which fastembed model the corpus uses, so a future re-index drift would surface fast.
2. **Answers buried inline.** Long, citation-heavy answers are easier to read in a side panel than inline in the chat scroll. The agent forces the final answer through `lobe-artifacts` so it lands as a markdown artifact the user can scroll, copy, and download.

## How it works

1. **Corpus discovery**: on the first question of a topic, the agent fires a small fan-out of broad `qdrant-find` queries (e.g. "introduction overview", "architecture system design", "evaluation benchmark") and collects the unique `file_path` values from the responses. That list — discovered, not hardcoded — is the working set for the rest of the conversation. Adding or removing documents from the corpus is therefore zero-touch on the agent.
2. The agent decomposes the user's question into 1–4 retrieval queries and calls `qdrant-find` once per query (parallel where possible).
3. It reads the returned chunks (each tagged with its `file_path` metadata).
4. Anything not in the corpus is clearly tagged `[outside corpus]` — the agent never fabricates corpus content.
5. The final synthesis is wrapped in:
   ```
   <lobeArtifact identifier="rag-answer" type="text/markdown" title="…">
   # …
   …grounded body with inline `(filename.ext)` citations and blockquoted evidence…
   ## Sources
   - file_a.pdf
   - file_b.html
   </lobeArtifact>
   ```

That tag is what LobeChat's `lobe-artifacts` plugin recognizes; the chat shows a small artifact card and the side panel opens with the rendered markdown.

## Sample prompts

- *"Define retrieval-augmented generation in one paragraph, then summarize how the technique evolved between Lewis 2020 and the Gao 2023 survey. Quote at least one passage from each paper."*
- *"Compare Naive RAG, Advanced RAG and Modular RAG using the Gao 2023 survey only."*
- *"What does the `mcp-server-qdrant` README say about its tool surface and embedding model?"*
- Trap: *"What is OpenAI's gpt-4.1-mini price per million tokens in 2026?"* — must answer `[outside corpus]`.

## Verifying it is wired

```bash
docker exec shared-postgres psql -U postgres -d lobechat \
  -c "SELECT id, title, model, plugins FROM agents WHERE id='agt_RagSage01';"

docker exec shared-postgres psql -U postgres -d lobechat \
  -c "SELECT s.title, ats.agent_id FROM sessions s JOIN agents_to_sessions ats ON ats.session_id=s.id WHERE ats.agent_id='agt_RagSage01';"

# corpus is reachable via MCP
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)
curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers \
  | jq '.data[] | select(.name=="qdrant-mcp") | {status, tools:(.tools|length)}'
```

## Recreate from scratch

Follow [`lobechat-assistants.md`](lobechat-assistants.md). Specifics for this agent:

- `AGENT_ID=agt_RagSage01`, `SESSION_ID=ssn_RagSage01`, `slug=rag-sage`.
- `plugins='["mcphub-qdrant","lobe-artifacts"]'`.
- `avatar='📚'`, `background_color='#3b2a1a'`.
- System prompt source: keep it in `/tmp/rag_agent_prompt.txt` while developing; commit to repo once finalized. Patch into the row with `pg_read_file('/tmp/…')`.

## Related docs

- [`docs/rag-demo/README.md`](rag-demo/README.md) — the corpus itself, indexing pipelines, prompt sample.
- [`docs/lobechat-assistants.md`](lobechat-assistants.md) — generic recipe for creating any LobeChat agent.
- [`docs/mcp-onboarding.md`](mcp-onboarding.md) — the MCP plugin (`mcphub-qdrant`) is registered there.
