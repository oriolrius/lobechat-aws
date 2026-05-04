#!/usr/bin/env python3
"""Render Flyway migration templates by substituting ${VAR} placeholders
with values from .env.flyway. Variables ending in _B64 are base64-decoded
before substitution. Output goes to .build/<db>/V*.sql for flyway to apply.
"""
from __future__ import annotations

import base64
import os
import re
import shutil
import sys
from pathlib import Path
from string import Template

ROOT = Path(__file__).resolve().parent
ENV_FILE = ROOT / ".env.flyway"
BUILD = ROOT / ".build"
DBS = ["lobechat", "casdoor", "litellm"]


def load_env() -> dict[str, str]:
    if not ENV_FILE.exists():
        print(f"error: {ENV_FILE} missing. cp .env.flyway.example .env.flyway", file=sys.stderr)
        sys.exit(2)
    env: dict[str, str] = {}
    for line in ENV_FILE.read_text().splitlines():
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        env[k.strip()] = v.strip()
    # decode _B64 -> non-suffixed name
    out: dict[str, str] = {}
    for k, v in env.items():
        if k.endswith("_B64"):
            out[k[:-4]] = base64.b64decode(v).decode()
            out[k] = v
        else:
            out[k] = v
    return out


class SafeTemplate(Template):
    """Allows $VAR and ${VAR}; leaves unknown placeholders intact."""
    idpattern = r"[A-Za-z_][A-Za-z0-9_]*"


def render_db(db: str, env: dict[str, str]) -> int:
    src = ROOT / db
    dst = BUILD / db
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True)
    n = 0
    for f in sorted(src.glob("V*.sql")):
        rendered = SafeTemplate(f.read_text()).safe_substitute(env)
        # Note: literal ${VAR} occurrences for unknown names are left as-is.
        # This is intentional — seed data legitimately contains literal env-var
        # references (plugin manifests, agent settings). Only known scrub
        # placeholders get substituted.
        (dst / f.name).write_text(rendered)
        n += 1
    print(f"  {db}: rendered {n} files -> {dst}")
    return n


def main() -> int:
    env = load_env()
    BUILD.mkdir(exist_ok=True)
    for db in DBS:
        if not render_db(db, env):
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
