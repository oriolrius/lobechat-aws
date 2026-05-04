# Flyway Provisioning

Versioned, secret-free baseline of the three live Postgres databases
(`lobechat`, `casdoor`, `litellm`) suitable for re-provisioning a fresh
host with the exact configuration of the working stack.

## Layout

```
db/flyway/
├── lobechat/
│   ├── V1__baseline_schema.sql   # pg_dump --schema-only
│   └── V2__baseline_seed.sql     # data, secrets templated as ${VAR}
├── casdoor/                      # same shape
├── litellm/                      # same shape (empty DB)
├── .env.flyway.example           # placeholder names — fill with real secrets
├── .env.flyway                   # gitignored, holds real secrets
├── scrub.py                      # one-shot: extracts secrets from a fresh
│                                 # dump into .env.flyway and rewrites V2 files
├── render.py                     # substitutes ${VAR} -> values from .env.flyway
│                                 # output -> .build/<db>/V*.sql
└── provision.sh                  # render + flyway migrate per DB
```

Ephemeral tables excluded from V2:
- `lobechat`: `nextauth_*`, `oidc_*`, `oauth_handoffs`, `async_tasks`
- `casdoor`: `session`, `token`, `verification_record`

## First-time setup

```bash
cp db/flyway/.env.flyway.example db/flyway/.env.flyway
# Fill values. _B64 vars hold base64 of multiline content (cert PEM).
```

## Provision a fresh host

```bash
./db/flyway/provision.sh           # render templates + flyway migrate all DBs
./db/flyway/provision.sh info      # show flyway state per DB
./db/flyway/provision.sh migrate lobechat   # single DB
./db/flyway/provision.sh render    # render only (no DB writes)
```

`provision.sh` uses the `flyway/flyway:10` Docker image with `--network host`
so the host's `localhost:47003` Postgres is reachable. Connection params come
from the main `.env` (`POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`,
`POSTGRES_PASSWORD`).

## Refresh baseline from current live DB

When the working stack drifts and you want to re-snapshot:

```bash
# dump fresh schema + seed (excluding ephemeral tables)
export PATH="/usr/lib/postgresql/16/bin:$PATH" PGPASSWORD=postgres
LOBE_SKIP="--exclude-table-data=nextauth_sessions ... (see provision.sh git history)"
pg_dump -h localhost -p 47003 -U postgres --schema-only --no-owner --no-privileges lobechat > db/flyway/lobechat/V1__baseline_schema.sql
pg_dump -h localhost -p 47003 -U postgres --data-only --inserts --no-owner --no-privileges $LOBE_SKIP lobechat > db/flyway/lobechat/V2__baseline_seed.sql
# (repeat for casdoor + litellm with their respective skip lists)

# re-scrub (idempotent — only re-extracts known secret patterns)
python3 db/flyway/scrub.py
```

If you add a new secret column, edit `SCRUB_RULES` in `scrub.py` first.

## Adding new versioned migrations

Append `V3__your_change.sql` etc. inside the relevant DB directory.
Flyway tracks state in `flyway_schema_history`. V1/V2 are the immutable
baseline; never edit them by hand — re-dump instead.

## Relationship to dbmate

The pre-existing `db/migrate` (dbmate) flow remains untouched and still
operates on `db/schema.sql` + `db/seed.sql` for the `lobechat` DB only.
Flyway is the new multi-DB path; both can coexist.
