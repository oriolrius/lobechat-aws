#!/usr/bin/env bash
# Flyway-based provisioning: creates DBs (lobechat, casdoor, litellm) from
# versioned migrations under db/flyway/<db>/V*.sql. Secrets are templated
# via ${VAR} placeholders, substituted from .env.flyway at apply time.
#
# Usage:
#   ./db/flyway/provision.sh                  # render + migrate all DBs
#   ./db/flyway/provision.sh render           # render only (no migrate)
#   ./db/flyway/provision.sh info             # flyway info per DB
#   ./db/flyway/provision.sh clean            # DROP all rows + reset history
#   ./db/flyway/provision.sh migrate <db>     # migrate single db
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUILD_DIR="$SCRIPT_DIR/.build"
DBS=(lobechat casdoor litellm)

# Load main .env for postgres connection
if [[ -f "$ROOT_DIR/.env" ]]; then
    set -a; source "$ROOT_DIR/.env"; set +a
fi
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-47003}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_PASS="${POSTGRES_PASSWORD:-postgres}"
export PGPASSWORD="$DB_PASS"
export PATH="/usr/lib/postgresql/16/bin:$PATH"

ensure_db() {
    local db="$1"
    if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -tAc \
            "SELECT 1 FROM pg_database WHERE datname='$db'" | grep -q 1; then
        echo "  creating database $db"
        createdb -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$db"
    fi
}

render() {
    echo "==> rendering migrations from .env.flyway"
    python3 "$SCRIPT_DIR/render.py"
}

flyway_run() {
    local db="$1"; shift
    docker run --rm --network host \
        -v "$BUILD_DIR/$db:/flyway/sql:ro" \
        flyway/flyway:10 \
        "-url=jdbc:postgresql://$DB_HOST:$DB_PORT/$db" \
        "-user=$DB_USER" \
        "-password=$DB_PASS" \
        "-locations=filesystem:/flyway/sql" \
        "-baselineOnMigrate=true" \
        "-baselineVersion=0" \
        "$@"
}

cmd="${1:-all}"
case "$cmd" in
    render) render ;;
    info)
        for db in "${DBS[@]}"; do
            echo "==> $db"
            ensure_db "$db"
            flyway_run "$db" info
        done
        ;;
    clean)
        read -rp "DROP all data in ${DBS[*]}? [y/N] " ans
        [[ "$ans" == "y" ]] || exit 1
        for db in "${DBS[@]}"; do flyway_run "$db" -cleanDisabled=false clean; done
        ;;
    migrate)
        target="${2:?usage: provision.sh migrate <db>}"
        render
        ensure_db "$target"
        flyway_run "$target" migrate
        ;;
    all|"")
        render
        for db in "${DBS[@]}"; do
            echo "==> migrating $db"
            ensure_db "$db"
            flyway_run "$db" migrate
        done
        ;;
    *) echo "unknown: $cmd"; exit 2 ;;
esac
