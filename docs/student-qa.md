# Student Q&A — LobeChat Local Stack

Consolidated answers grouped by topic. Duplicates merged.

---

## 1. MCP & MCPHub: Purpose and Role

### Q (Ismail, Irene): What triggers the use of MCPHub? When does the system choose to call MCP instead of answering directly?

The LLM decides. vLLM serves Gemma 4 with native function calling — at each turn it sees the available tool list (injected by LobeChat from MCPHub's catalog). If the user prompt needs external data or side effects (file read, SSH command, vector search, AWS API), the model emits a `tool_call` JSON block instead of a plain text answer. LobeChat catches the call, routes it to MCPHub, runs the tool, returns the result, and the model continues. No tool need → plain answer, no MCP traffic.

### Q (Nick): Difference between standard MCP and MCPHub?

Standard MCP = one client ↔ one server, stdio or HTTP. MCPHub = aggregator/proxy: it mounts ~10 MCP servers behind a single HTTP endpoint, multiplexes tool listings, handles auth/secrets, and presents one unified interface to LobeChat. Without MCPHub, LobeChat would need N separate connections and process supervision for each stdio server.

### Q (Marc, Lucia): How does MCPHub communicate with vLLM during a request? How does it understand vLLM instructions?

MCPHub does NOT talk to vLLM. Flow: vLLM emits tool-call JSON → LobeChat parses it → LobeChat sends HTTP request to MCPHub → MCPHub dispatches to the correct backend MCP server → result returns the same path back to vLLM as a `tool` message. MCPHub is a tool execution layer, not an LLM client.

### Q (Lucas): Why does vLLM come before MCPHub?

The model must decide *whether* to call a tool. That decision happens during inference (vLLM). MCPHub only executes after the model emits a tool call. Logical order: prompt → LLM → (maybe) tool → LLM again → answer.

### Q (Léa, Francis, Nodar, Dan): Does MCP just perform API calls? Why use MCP instead of direct API calls / hardcoded integrations?

MCP often wraps API calls but adds: standardized schema (tools, resources, prompts), discovery (LLM sees tool list dynamically), transport abstraction (stdio/HTTP/SSE), auth handling, and language-agnostic clients. Hardcoded integrations require code changes per tool, per app. With MCP, any MCP-aware client (LobeChat, Claude Desktop, Cursor) reuses the same servers. Decoupling = swap LLM, swap UI, keep tools.

### Q (Jo): Does LobeChat call an MCP tool (ssh-exec) and that tool performs the SSH on the AI's behalf? Common language for calling tools?

Yes exactly. ssh-exec MCP server holds the SSH client and credentials; LobeChat sends a structured tool call (`{tool: "ssh_exec", args: {...}}`); server runs ssh, returns stdout. MCP = common JSON-RPC schema so the model talks to any tool the same way.

### Q (Lucía): How are permissions managed for filesystem / SSH MCP tools?

Per-server config in `config/mcp_settings.json`: ssh-exec uses a command whitelist; filesystem MCP is scoped to bind-mounted paths; linux-sandbox runs as uid 1000 inside an isolated container. No user-level RBAC — restrictions enforced at the server config layer.

### Q (Carl): Why does MCPHub need a custom Dockerfile?

Stdio MCP servers run as child processes inside the MCPHub container and need system deps not in the upstream image: graphviz + libgraphviz-dev (for `diagrams` package), gcc (build native deps), docker.io (to spawn d2-mcp container-in-container). Hence `dockerfiles/mcphub.Dockerfile` extends `samanhappy/mcphub:latest`.

---

## 2. Hayhooks (REST vs MCP)

### Q (Ismail, Gabi): What is a Haystack pipeline? Why does Hayhooks appear twice (47012 REST, 47013 MCP)?

Haystack = Python framework for RAG/LLM pipelines (retriever → reranker → generator chains). Hayhooks deploys those pipelines as services. Two ports = two transports of the same pipelines:
- **47012 REST** (FastAPI + Swagger) — for human/API clients
- **47013 MCP** (`hayhooks mcp run`) — same pipelines exposed as MCP tools, consumed by MCPHub → LobeChat

One backend, two interfaces.

### Q (Carlos): Difference between MCPHub and Hayhooks MCP?

MCPHub = aggregator of many MCP servers. Hayhooks MCP = one specific MCP server that exposes Haystack pipelines. MCPHub *includes* Hayhooks MCP as one of its registered backends.

---

## 3. RAG, Qdrant, Postgres

### Q (Rodrigo, Rayen, Nicolau): Why both PostgreSQL (with pgvector) and Qdrant?

Postgres stores LobeChat operational data (users, sessions, messages, agent configs). Qdrant is a dedicated vector DB for RAG corpora — better recall/latency at scale, HNSW indexing, payload filtering. pgvector exists but isn't used here for the RAG path. Separation of concerns: transactional data ≠ embedding search.

### Q (Carlos): How does Qdrant make RAG possible?

Documents → chunked → embedded (vectors) → stored in Qdrant collection (`rag-demo`). At query time: user prompt → embedded → nearest-neighbor search in Qdrant → top-k chunks returned → injected into LLM prompt as context. Qdrant is the recall layer.

### Q (Juri): Which service stores uploaded PDFs, and which lets AI search them?

MinIO stores raw files. Qdrant stores embeddings of chunks extracted from those files. Hayhooks pipeline (or qdrant-mcp) does the search. Postgres tracks file metadata / ownership.

### Q (alice): What generates embeddings stored in Qdrant? Separate service not shown?

Embeddings come from an external embedding model — OpenRouter API (configured via `OPENROUTER_API_KEY`) or the embedding endpoint Hayhooks calls. Not a container in the stack; it's an outbound HTTP call.

### Q (Margi): Why does Qdrant connect directly to LobeChat instead of going through MCPHub?

It doesn't — Qdrant is reached via `qdrant-mcp` (stdio MCP server) registered in MCPHub. LobeChat → MCPHub → qdrant-mcp → Qdrant. Direct LobeChat→Qdrant connection is not used in the RAG path.

---

## 4. LobeChat as Agent

### Q (Juri): What makes LobeChat an "agent" — isn't it just a UI relaying input to vLLM?

LobeChat is the agent *runtime*. It manages: system prompt, tool list, multi-turn loop (LLM → tool → LLM → …), session state, and termination. The "thinking" lives in the LLM (vLLM/Gemma); LobeChat orchestrates the loop and tool dispatch. Without it, vLLM is just a stateless completion endpoint.

---

## 5. Authentication (Casdoor)

### Q (Nick): Difference between Casdoor and Supabase?

Casdoor = open-source identity/SSO provider (OIDC, OAuth2, SAML). Supabase = full BaaS (auth + Postgres + storage + realtime). Overlap only in auth. This stack uses Casdoor for auth-only and pairs it with separate Postgres and MinIO.

### Q (Nacho): Why is Casdoor separate, not built into LobeChat?

Separation of concerns: auth is reusable across apps, has its own admin UI, supports multiple identity providers (Google, GitHub, LDAP), and is replaceable. Bundling auth = vendor lock-in to LobeChat's auth model. Industry standard = external IdP.

---

## 6. MinIO & Storage

### Q (Rafa, Ismail): What does MinIO store?

User-uploaded files (PDFs, images, attachments), agent-generated artifacts (e.g., diagrams from Cloud Diagram Assistant rendered as PNG and uploaded to a public bucket so LobeChat renders them inline). S3-compatible API.

---

## 7. Local vs Cloud LLM

### Q (Nono): Why run the model locally instead of using OpenAI/Anthropic API?

Privacy (data stays on premises), cost predictability (no per-token bill), latency (no round-trip), no rate limits, offline capability, regulatory compliance. Tradeoff = GPU cost + lower model quality vs frontier APIs. Stack supports both: local vLLM and Anthropic via Meridian.

### Q (Calin): How does the architecture preserve tool-calling when switching vLLM → Anthropic via Meridian?

Both endpoints expose OpenAI-compatible tool-calling schemas. Meridian translates between Anthropic's tool-use format and OpenAI's. LobeChat sees one interface either way. Tool definitions in MCPHub are unchanged. Switch = change provider in LobeChat's `ai_providers` row.

---

## 8. Architecture & Deployment

### Q (Alain): Why split into separate containers instead of monolith?

Independent scaling (GPU only on vLLM), independent upgrades, language diversity (Python pipelines, Node MCP servers, Go services), failure isolation, image size, security boundaries, reusability across stacks. Monolith would be unmaintainable.

### Q (Carlos): What happens step-by-step when I send a message?

1. Browser → LobeChat (47000)
2. LobeChat checks session in Postgres (47003)
3. LobeChat assembles prompt + tool list from MCPHub (47008)
4. POST to vLLM (47007) with messages + tools
5. vLLM/Gemma generates: either text or `tool_call`
6. If tool_call: LobeChat → MCPHub → MCP server → backend (Qdrant/SSH/etc) → result back
7. Result appended to messages, loop to step 4
8. Final text streamed to browser, persisted in Postgres

### Q (Carolina): If Postgres crashes, does LobeChat go down immediately?

Yes for stateful operations — login, history, agent config, message persistence all hit Postgres. UI may load (cached assets) but new conversations fail. Casdoor also depends on Postgres → auth breaks too.

### Q (Nicolau, Samad): Which ports should be public vs private? Why are inbound ports 22, 3210, 9000, 9001 open to 0.0.0.0/0?

**Public**: 47000 (LobeChat), 47002 (Casdoor login). **Private**: everything else (Postgres 47003, vLLM 47007, MCPHub 47008, Qdrant 47010/11, Hayhooks 47012/13, MinIO 47005/06).

Open SSH/web ports to `0.0.0.0/0` = security smell. Should be restricted to VPN / known IP ranges via security group or firewall. SSH should use key-only auth + fail2ban minimum.

