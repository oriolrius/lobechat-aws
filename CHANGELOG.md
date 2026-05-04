## v0.6.0 (2026-05-04)

### Feat

- **db**: flyway versioned migrations with secret-templated baseline
- **mcp**: add linux-sandbox MCP server with persistent zellij shell
- **vllm**: bump max-model-len 16384 → 32768
- **mcp**: register five new MCP servers in MCPHub
- **stack**: add Qdrant + Hayhooks vector RAG services
- **vllm**: switch to Gemma 4 E4B-it with native function calling
- **db**: add dbmate migration system with schema and seed support
- **lobechat**: use OpenRouter for embeddings

### Fix

- **lobechat**: suppress changelog modal and update-check redirect

## v0.5.2 (2026-01-27)

### Fix

- **mcp**: mount ~/.aws for dynamic credential refresh

## v0.5.1 (2026-01-27)

### Feat

- **mcp**: add AWS Documentation MCP server

## v0.5.0 (2026-01-27)

### Feat

- **mcp**: add AWS resources operations MCP server with test

## v0.4.3 (2026-01-27)

### Feat

- **agents**: add generic screenshot service agent for lobe-chat-agents

## v0.4.2 (2026-01-27)

## v0.4.1 (2026-01-27)

### Fix

- **playwright**: add output-dir and unrestricted file access

## v0.4.0 (2026-01-27)

### Feat

- add MCP server tests and enhance MCPHub configuration

## v0.3.0 (2026-01-27)

### Feat

- add MCPHub integration with LobeChat hotfix
- add vLLM local GPU inference with Gemma 3 270M model

## v0.2.0 (2026-01-26)

### Refactor

- centralize configuration and switch to OpenRouter

## v0.1.0 (2026-01-26)

### Feat

- initial LobeChat local stack setup
