<!--
  REPORT.md — Final Project evidence file.

  Rules:
  - Keep it ≤ 2 printed pages.
  - All screenshots embedded inline (commit PNGs next to this file).
  - All command outputs pasted as fenced code blocks, captured with `tee`
    (not retyped). Keep timestamps visible.
  - Identity binding: in every screenshot, your ESADE email AND the public
    HTTPS URL must be visible in the same frame (browser tab, terminal
    prompt, or watermark).
  - URL must be reachable until 24 h after the exam day. Down = practical 0.
  - Missing item = -5% on practical, each.

  Replace every `TODO` and remove these HTML comments before submitting.
-->

# Final Project — Evidence Report

## 1. Identity

| Field | Value |
|---|---|
| Student name | TODO |
| ESADE email | TODO |
| GitHub repo URL | TODO (must be **private**; user `joseporiolrius` invited as collaborator) |
| Latest commit SHA | TODO (`git rev-parse HEAD`) |
| Final tag | TODO (`final-vX.Y.Z`) |

## 2. Public URL

<!-- Grader clicks. If down or HTTP, practical = 0. -->

**[https://TODO](https://TODO)**

## 3. Screenshot — LobeChat over HTTPS, logged in

<!--
  Frame must show:
    - browser address bar with padlock + the public HTTPS URL
    - LobeChat home page after Casdoor login
    - your ESADE email visible (browser profile, account menu, or terminal
      next to the browser with the prompt)
  Commit as: lobechat-https.png
-->

![lobechat-https](lobechat-https.png)

## 4. Screenshot — chat working (streaming + MCP)

<!--
  One frame showing:
    - a chat reply that streamed (any model)
    - one MCP tool call result rendered in the same chat
  Commit as: chat-mcp.png
-->

![chat-mcp](chat-mcp.png)

## 5. Public reachability — `curl -sI https://<host>/`

<!--
  Run from OUTSIDE the EC2 (your laptop). Paste full output.
  Expected: HTTP/2 200 or 302, valid TLS, Set-Cookie with Secure flag if
  Casdoor session was hit.
-->

```
$ curl -sI https://TODO/
TODO
```

## 6. Negative test — port 47000 closed

<!--
  Run from OUTSIDE the EC2 against the EIP. Paste full output.
  Expected: connection refused or timed out.
-->

```
$ curl -v --max-time 5 http://TODO:47000/
TODO
```

## 7. Stack runtime — `docker compose ps`

<!--
  Run on the EC2. Paste full output.
  All required services must show Up (healthy where applicable):
  lobe-chat, casdoor, postgres, minio, qdrant, mcphub, plus your reverse proxy.
-->

```
$ docker compose ps
TODO
```
