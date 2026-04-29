# `linux-sandbox` MCP server

Disposable Ubuntu 24.04 container exposed as an MCP server. Lets agents drive a real shell with `ssh`, `aws`, `kubectl`, and `eksctl` — without touching the host.

## What it is

| Layer | Detail |
|-------|--------|
| Image | `lobechat-aws-linux-sandbox:latest` (built from `dockerfiles/sandbox.Dockerfile`) |
| Container | `linux-sandbox` (idle `tail -f /dev/null`, restart `unless-stopped`) |
| MCP server | [`@wonderwhy-er/desktop-commander`](https://www.npmjs.com/package/@wonderwhy-er/desktop-commander) launched on demand by mcphub via `docker exec -i -u oriol -w /home/oriol linux-sandbox npx -y …` |
| Sandbox user | `oriol` (uid/gid 1000, matches the host) with **passwordless sudo** |
| Tool count | 26 (shell exec, file read/write, edit, search, …) |
| LobeChat plugin | `mcphub-linux-sandbox` |
| Pre-built agent | `agt_LinuxBox01` — *Linux Assistant* 🐧 (session slug `linux-assistant`) |

## Pre-installed in the sandbox

- Coreutils + `curl`, `wget`, `unzip`, `tar`, `git`, `jq`, `vim-tiny`, `python3`, `nodejs` (20)
- **OpenSSH client** — host's `~/.ssh` is bind-mounted at `/home/oriol/.ssh`, so the user's keys/`known_hosts`/`config` work as-is
- **AWS CLI v2**
- **kubectl** (latest stable)
- **eksctl** (latest)
- **zellij** (latest stable, musl static) + `sb-zj` helper — see *Persistent shell* below

## Persistent shell — `sb-zj` + zellij

Each desktop-commander `start_process` call spawns a fresh `/bin/sh -c <cmd>`, so env vars, `cd`, and ssh-agents do not survive between calls. To get a stateful shell that also survives `mcphub` stdio child restarts, the image runs a persistent zellij session named **`sb`** (auto-started by the entrypoint) and ships a wrapper:

```
sb-zj '<shell command>'
```

`sb-zj` is idempotent: if `sb` is missing it spawns it (dismissing the welcome via the pre-installed `~/.config/zellij/config.kdl`), then sends the command to the session and returns the captured screen via `zellij action dump-screen`. Long output: pipe inside the helper — `sb-zj 'cmd | tail -200'`.

The Linux Assistant agent's role pins `sb-zj` as the **mandatory** path for any shell command. Bare `start_process` invocations are reserved for the file-only desktop-commander tools (`read_file`, `write_file`, `list_directory`, …).

`~/.aws` is **not** mounted into the sandbox — credentials must be supplied via `aws configure`, env vars, or the existing `aws-resources-operations` MCP path.

## How it is wired

1. `docker-compose.yml` defines the `linux-sandbox` service with the `~/.ssh` bind mount.
2. `mcphub` already mounts `/var/run/docker.sock`, so it can `docker exec` into the sandbox to spawn the MCP server stdio process on demand.
3. `config/mcp_settings.json` registers the server:
   ```json
   "linux-sandbox": {
     "type": "stdio",
     "command": "docker",
     "args": ["exec","-i","linux-sandbox","npx","-y","@wonderwhy-er/desktop-commander@latest"]
   }
   ```
4. `user_installed_plugins` row `mcphub-linux-sandbox` points LobeChat at `http://mcphub:3000/mcp/linux-sandbox`.
5. `agents` row `agt_LinuxBox01` enables the plugin and ships a system prompt that scopes the agent to the sandbox (no host access, ask before destructive ops).

## Bring it up

```bash
docker compose build linux-sandbox
docker compose up -d linux-sandbox
docker compose down mcphub && docker compose up -d mcphub   # re-poll mcp_settings.json
```

Sanity check:

```bash
TOKEN=$(curl -s -X POST http://localhost:47008/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' | jq -r .token)
curl -s -H "x-auth-token: $TOKEN" http://localhost:47008/api/servers \
  | jq '.data[] | select(.name=="linux-sandbox") | {status, tools: (.tools|length)}'
```

Expected: `status: "connected"`, `tools: 26` (or however many the current desktop-commander release ships).

## Pin the desktop-commander version

`@wonderwhy-er/desktop-commander@latest` is convenient but each release can change tool surface. To pin, replace `@latest` with a specific tag (e.g. `@0.2.40`) in `config/mcp_settings.json` and `down/up` mcphub.

## Caveats

- First spawn pulls the npm package via `npx` inside the sandbox container; allow ~10–20 s on a cold start.
- `~/.ssh` is mounted **read-write** so `known_hosts` updates persist; the host file is the same one your user account uses, so be deliberate about what the agent SSHes into.
- Anything written under `/home/oriol` outside the bind-mounted `~/.ssh` directory is ephemeral — the container is restartable but not authoritative storage.
- The default `ubuntu` user that ships in `ubuntu:24.04` is renamed to `oriol` at build time so uid/gid 1000 lines up with the host. If your host user is **not** uid 1000, edit `dockerfiles/sandbox.Dockerfile` to recreate the user with the matching id (`groupadd -g <gid> oriol && useradd -u <uid> -g oriol -G sudo -m -s /bin/bash oriol`) and rebuild.

## Related

- [`mcp-onboarding.md`](mcp-onboarding.md) — generic recipe (this server follows it)
- [`lobechat-assistants.md`](lobechat-assistants.md) — how the Linux Assistant agent is seeded
