# Final Project — DevOps Course

**Audience**: double-degree students (Business + AI).
**Allowed tools**: coding agents (Claude Code, Cursor, etc.), web search, AWS docs.
**Forbidden**: copy-paste from another student, AI-assisted answers without the corresponding `chat-dump.md`.

---

## 1. Goal

Demonstrate end-to-end ownership of a real, multi-component AI platform:

1. **Deploy** the LobeChat stack (this repo) on a single AWS EC2 instance.
2. **Reason** about the system as a product, an architecture, an economic asset, and a strategic choice.

The technical bar is intentionally low (lift-and-shift the existing `docker-compose.yml`). The grade weight sits on the **written analysis**: this is where business + AI judgment is measured.

---

## 2. Practical part — deploy on EC2

### 2.1 Required outcome

A reachable LobeChat instance (`http://<ec2-public-dns>:47000`) running the full stack defined in `docker-compose.yml` of this repo, on **one EC2 instance** in your AWS sandbox account.

### 2.2 Constraints

- Region: `eu-west-1`.
- Instance: any x86_64 type with ≥ 4 vCPU / ≥ 16 GB RAM / ≥ 60 GB EBS gp3. GPU **not** required. LLM backend is your choice — any OpenAI-compatible (or otherwise pluggable into LobeChat) endpoint works: vLLM, Ollama, LM Studio, AWS SageMaker endpoint, AWS Bedrock, OpenRouter, OpenAI API, Anthropic, Groq, etc. Justify your pick in Q3 (cost) and Q4 (build-vs-buy).
- OS: Ubuntu 24.04 LTS (Canonical AMI via SSM public parameter, **no hardcoded AMI ID**).
- LobeChat must be exposed publicly only through a reverse proxy / API gateway / load balancer of your choice (self-provisioned on the EC2, e.g. Caddy / Nginx / Traefik, or AWS-managed, e.g. ALB + ACM, CloudFront, API Gateway). HTTPS with a valid certificate is mandatory. Justify the choice (self vs managed, cost, ops burden) in Q2.
- Secrets: `.env` populated via SSM Parameter Store **or** AWS Secrets Manager. No secrets in git.

### 2.3 Evidence to capture

All evidence goes into a single file: [`docs/evidence/REPORT.md`](evidence/REPORT.md). The placeholder version of that file already lives in the repo and contains the full template, capture rules, and inline comments explaining what each section must contain.

Fill it in. Do not create extra folders, manifests, or hashes.

Graded qualitatively against the rubric in §5. Weights live in §4.

---

## 3. Written analysis — 4 questions

Each answer 800–1500 words. One folder per question under `docs/evidence/`:

```
docs/evidence/q1/
  a1.md          # the answer itself
  chat-dump.md   # full AI chat transcript used to produce a1.md, or `NO_AI_USED` if AI was not used
  assets/        # optional: diagrams, images embedded in a1.md
```

Same structure for `q2/`, `q3/`, `q4/`.

`chat-dump.md` policy: **mandatory in every question folder**. First line of the file is the declaration marker:

- `NO_AI_USED` (exact string, position 0) — no AI tool used to produce `a1.md`. File can stop there.
- anything else — first line + body must contain the full AI transcript(s) (tool/model, prompts, responses, what you kept/changed).

Missing file = academic integrity issue. AI fingerprints in `a1.md` while `chat-dump.md` says `NO_AI_USED` = academic integrity issue. Using AI is fine; hiding it is not.

### Q1 — Use case design

Describe in detail a **realistic, vertical-specific** use case where this stack delivers measurable value.

Required sections:

- **Context**: industry, company size, problem today.
- **Personas**: 2–3 user roles, their workflows, pain points.
- **Journey**: step-by-step interaction with LobeChat. Which MCP tools fire? What data flows where? Which model handles which step?
- **Why this stack vs ChatGPT/Copilot**: at least 3 concrete reasons grounded in the use case.

### Q2 — 3-environment architecture evolution

Propose how this stack evolves on AWS across **dev**, **stage**, **prod** environments.

Required sections:

- **Per-env table**: for each component (LobeChat, Casdoor, Postgres, MinIO, Qdrant, MCPHub, Hayhooks, vLLM/LLM provider) state: where it runs (EC2 type / managed service), why, what changes vs other envs.
- **Hard constraint**: Qdrant runs on **EC2 in all three envs** (justify EBS sizing, snapshot policy, instance recovery — no managed vector DB).
- **Hard constraint**: at least 4 AWS managed services used in prod (e.g., RDS, S3, Secrets Manager, ALB, ACM, Route53, Cognito, CloudWatch, Bedrock).
- **Promotion flow**: how code/config moves dev → stage → prod. Branching, tagging, approvals.
- **Data**: how dev gets realistic-but-safe data. How stage mirrors prod. How prod is backed up + restorable.
- **Trade-off table**: reliability vs cost vs ops complexity, scored per env.
- **Diagram**: one architecture diagram per env (3 total).

### Q3 — Cost model + unit economics

Estimate the monthly AWS bill for the prod environment at **3 scales**: 10 / 100 / 1000 monthly active users.

Required sections:

- **Assumptions**: messages/user/day, avg tokens in/out, RAG queries/message, file uploads MB/user, retention.
- **Line-item table per scale**: EC2 (instance + EBS), RDS, S3 (storage + requests + egress), data transfer, Bedrock/OpenRouter token cost, CloudWatch, Route53/ACM, Secrets Manager. Cite **current** AWS list price for `eu-west-1`, link to pricing page accessed during exam.
- **Top 3 cost drivers** at 1000 MAU.
- **2 cost-cutting levers**, each estimated to save ≥ 15% with quantified SLO/UX trade-off.
- **Unit economics**: cost per active user per month at each scale. Where does the curve break?
- **Pricing recommendation**: if you sold this as a product, what monthly fee per user covers cost + 50% margin at 100 MAU?

### Q4 — Build vs buy memo to the CTO

The CTO asks: "Why are we self-hosting LobeChat instead of buying ChatGPT Enterprise / Microsoft Copilot / Claude for Work?"

Write a **2-page executive memo** (≈ 1000 words) defending the self-hosted choice — or arguing against it if you genuinely conclude otherwise. Either position is gradeable; what matters is the reasoning.

Required content:

- **TL;DR** (3 bullets, top of page).
- **3-year TCO comparison**: self-hosted (your Q3 numbers) vs ChatGPT Enterprise (≈ $60/user/mo) vs Copilot ($30/user/mo) for a 200-user company.
- **Lock-in analysis**: data, identity, model, tooling. Exit cost for each option.
- **Data sovereignty + compliance**: GDPR, sector-specific (pick one — finance, health, legal, education).
- **Capability gap**: what self-hosted does that SaaS does not (MCP tools, custom RAG, model choice). What SaaS does that self-hosted does not (uptime SLA, support, mobile apps, refresh cadence).
- **Recommendation** with explicit conditions ("self-host **if** X, Y, Z; otherwise buy").
- **Reversal trigger**: what future event flips your recommendation?

Format: real memo. Header (To/From/Date/Subject), exec summary, body, decision, appendix. No academic prose.

---

## 4. Grading weights

| Item | Weight |
|---|---|
| Practical (live LobeChat over HTTPS + `REPORT.md`) | 30% |
| Q1 — Use case design                               | 17.5% |
| Q2 — 3-environment architecture evolution          | 17.5% |
| Q3 — Cost model + unit economics                   | 17.5% |
| Q4 — Build vs buy memo                             | 17.5% |

---

## 5. Rubric per written question (4-level)

| Level | Meaning                                                                                  |
| ----- | ---------------------------------------------------------------------------------------- |
| 0     | Missing, off-topic, or factually wrong on core claims                                    |
| 1     | Generic answer, could apply to any AI tool, no reference to this repo's specifics        |
| 2     | Specific to this stack, internally consistent, but shallow on trade-offs or numbers      |
| 3     | Specific, quantified, defends a position, surfaces non-obvious trade-offs, cites sources |

Pass = average ≥ 2 across the 4 questions **and** practical works.

---

## 6. Submission

Single GitHub repo (fork of `lobechat-aws`), **private**, with user `joseporiolrius` invited as collaborator. Link submitted via course form. Tag the final commit `final-vX.Y.Z` using Commitizen (`cz bump`).

---

## Appendix A — Why a domain name is required (and how to get one for free)

### A.1 Why a domain at all?

The exam asks for HTTPS, not plain HTTP. HTTPS is mandatory for three concrete reasons:

1. **Casdoor SSO + LobeChat OAuth callback**: many browsers (and OAuth providers) refuse to set or send cross-site cookies on plain HTTP. Without HTTPS the login flow silently fails with cookie / `SameSite` / `Secure` errors that look like random bugs.
2. **MCP transports + WebSocket / SSE**: streaming responses and several MCP servers use long-lived connections. Mixed-content rules and modern browser policies block them on HTTP origins or in HTTP iframes.
3. **Real-world DevOps**: shipping a service on `http://1.2.3.4:47000` is not a valid prod posture. The course evaluates production discipline, not lab tinkering.

A raw IP on port 47000 fails all three. Closing port 47000 and exposing 80/443 only is therefore enforced in §2.2.

### A.2 Why TLS depends on owning (or borrowing) a domain

A TLS certificate proves "this hostname is legitimately served by this server". Every public Certificate Authority (Let's Encrypt, ACM, ZeroSSL, …) refuses to issue a certificate unless you can prove control of a hostname. Proof methods:

- **HTTP-01**: CA fetches `http://<hostname>/.well-known/acme-challenge/...` → you must control DNS for `<hostname>` and run a server at the resolved IP.
- **DNS-01**: CA asks for a `_acme-challenge.<hostname>` TXT record → you must control DNS for the zone.
- **AWS internal validation** (ACM for CloudFront/ALB): same idea, DNS or email.

Consequences:

- **Raw IP addresses cannot get a certificate.** No public CA issues certs for IPs in this scenario.
- **AWS infrastructure hostnames are explicitly blocked**: Let's Encrypt refuses `*.compute.amazonaws.com` and `*.amazonaws.com`. ACM refuses to issue for `*.elb.amazonaws.com`. The default EC2 / ALB DNS names are dead ends for TLS.
- **Self-signed certs are not acceptable** here: browsers warn, OAuth callbacks break, and graders will mark this as failed HTTPS.

Therefore: **you need a hostname you control, on a domain a CA is willing to issue against**.

### A.3 Solutions when you do not own a domain

You are not required to buy a domain. Pick **one** of the following, document the choice in Q2, and prove it works:

1. **Wildcard-from-IP DNS services** (`sslip.io`, `nip.io`, `traefik.me`)

   - `1-2-3-4.sslip.io` → `1.2.3.4` automatically.
   - `traefik.me` already serves a valid wildcard TLS certificate, no Let's Encrypt issuance needed.
   - `sslip.io` / `nip.io` work with Let's Encrypt HTTP-01 via Caddy / Traefik / Nginx-acme on the EC2.
   - Risk: shared Let's Encrypt rate limit (50 certs/week/registered-domain). If many classmates hit the same provider on demo day, some get throttled. Use LE **staging** during dev, switch to production only near the demo.
2. **Free dynamic-DNS providers** (`DuckDNS`, `FreeDNS`, `No-IP`)

   - Each student gets their own subdomain (`<you>.duckdns.org`) → own LE rate-limit budget.
   - Requires a tiny cron / systemd timer to keep the IP record updated when the EIP ever changes.
3. **AWS CloudFront default domain** (`xxxx.cloudfront.net`)

   - CloudFront distributions get a free AWS-managed TLS certificate on `*.cloudfront.net`. No domain ownership required.
   - Configure: WebSocket upgrade enabled, origin read timeout ≥ 60 s, response compression disabled on the streaming behavior, `Accept` and `Cache-Control` forwarded, no caching of dynamic paths.
   - Lock the origin so the EC2 cannot be reached directly: custom header `X-CloudFront-Secret: <token>` checked in your reverse proxy, plus SG inbound on 80/443 limited to CloudFront's managed prefix list `com.amazonaws.global.cloudfront.origin_facing`.
   - Set `APP_URL=https://xxxx.cloudfront.net` (and matching Casdoor redirect URIs) **before** first boot. Recreating the distribution changes the hostname and breaks SSO.
4. **Your own domain** (only if you already have one)

   - Route 53 hosted zone + ACM cert for ALB / CloudFront, or external registrar + Let's Encrypt on EC2.
   - Cleanest option but costs money you do not need to spend for this exam.

Dead ends — do not waste time on these:

- Trying to obtain a certificate for `ec2-...compute.amazonaws.com` or `*.elb.amazonaws.com`.
- Self-signed certificates in the browser trust path.
- API Gateway in front of LobeChat — its proxy model does not handle the SSE / WebSocket usage cleanly.

### A.4 Why this matters and what you must validate

Picking an option is the easy part. The graded part is **proving the chosen solution actually carries a working LobeChat**. A green padlock on the home page is not enough. Validate end-to-end:

- [ ] Casdoor login flow completes from the public URL (no `Secure cookie` / `redirect_uri` errors).
- [ ] LobeChat chat streaming works (response tokens arrive incrementally — confirms SSE path).
- [ ] At least one MCP tool invoked from chat returns a result (confirms long-lived MCP transport works through the proxy / CDN).
- [ ] File upload to MinIO from chat works (confirms request size / timeout settings).
- [ ] Direct connection to the EC2 origin (`http://<eip>:47000`, `http://<eip>:443` bypassing the proxy hostname) is **rejected**, not just unreachable by accident.
- [ ] Browser shows a valid certificate chain on the public hostname (no warning, issuer is a public CA or AWS).

Document this checklist as passed in `docs/evidence/tls-validation.md` with timestamped screenshots. Failing any item = HTTPS not actually working = practical capped at 50%.

The lesson the exam is forcing you to internalize: **TLS, DNS, OAuth, and streaming protocols are coupled**. A "works on my laptop" stack is not the same system as a "served over HTTPS at a real hostname" stack. Discovering this on exam day is the wrong moment.
