#!/usr/bin/env python3
"""Scrub secrets from baseline seed SQL files.

Reads V2__baseline_seed.sql files in place, replaces hard-coded secret
values with ${PLACEHOLDER} markers, and writes the original values to
.env.flyway (created if missing, never overwriting existing entries).

Multiline / non-printable values are stored base64-encoded with a
_B64 suffix and decoded by provision.sh at apply time.
"""
from __future__ import annotations

import base64
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ENV_FILE = ROOT / ".env.flyway"

# (relative_path, search_pattern, placeholder_name, value_or_extractor, is_regex, is_b64)
# value_or_extractor: literal string OR callable(match)->str returning real value
SCRUB_RULES = [
    # casdoor application client_secrets (unique 40-char hashes)
    ("casdoor/V2__baseline_seed.sql",
     "dbf205949d704de81b0b5b3603174e23fbecc354",
     "CASDOOR_APP_LOBECHAT_CLIENT_SECRET", None, False, False),
    ("casdoor/V2__baseline_seed.sql",
     "fc76d8be000bc358c83712f6598754e054969994",
     "CASDOOR_APP_BUILTIN_CLIENT_SECRET", None, False, False),
    # casdoor user passwords (both same plaintext "pswd123") — replace_all
    ("casdoor/V2__baseline_seed.sql",
     "'pswd123'",
     "CASDOOR_USER_DEFAULT_PASSWORD", "pswd123", False, False),
    # casdoor ldap password — anchored to its INSERT row to avoid collisions
    ("casdoor/V2__baseline_seed.sql",
     r"('cn=buildin,dc=example,dc=com', ')([^']+)(', 'ou=BuildIn)",
     "CASDOOR_LDAP_BUILTIN_PASSWORD", None, True, False),
    # casdoor cert private_key (multiline PEM)
    ("casdoor/V2__baseline_seed.sql",
     r"(-----BEGIN RSA PRIVATE KEY-----\n[\s\S]*?-----END RSA PRIVATE KEY-----\n)",
     "CASDOOR_CERT_BUILTIN_PRIVATE_KEY", None, True, True),
    # lobechat ai_providers.key_vaults — encrypted blobs (iv:salt:ciphertext)
    # unique 5-tuple matched by literal substring; provider-specific suffix
    ("lobechat/V2__baseline_seed.sql",
     "9eb292a96ba318f7ddf0f721:b8122ab003cd272b202cde053bc06efb:00d2566e5e19e7a850da04ce2633d9041f2501a93080b66696b9065a8ab5e89a377d9d27c0bc3c75535b5486be7c63bab52885df",
     "LOBECHAT_AIPROVIDER_GOOGLE_KEY_VAULTS", None, False, False),
    ("lobechat/V2__baseline_seed.sql",
     "7af4c95696aea770ed7d163c:566905d720a300a4fdbc9024c1ba47f4:ab2308561f49c51bc619dee02f3b80454cf816d1c8e0244e67ef691d71a2e7d0b0b4dbcb30e020b5bf77dc7e5215b3f0ace0488ca930bb0933775db8cae39c26c23b406ed7188193b33965633905300d31820bfa9327a031f675256aabd9d5f03b25efd4505c",
     "LOBECHAT_AIPROVIDER_ANTHROPIC_KEY_VAULTS", None, False, False),
    ("lobechat/V2__baseline_seed.sql",
     "a0c286eedcaa2e878a56c9d4:ac5dd33c9986872cc1e6c1420a69d1b8:db7a30ea07b064b541a893ceca315c0dfc057153294c81ca8753f70e578995c34d36be2bb663b84b94f914f76459337a1817bc2d6359508414760c262c",
     "LOBECHAT_AIPROVIDER_VASTAI_KEY_VAULTS", None, False, False),
    ("lobechat/V2__baseline_seed.sql",
     "f49f92846a5b20fc7860edc5:7844158a03a894dfcb6062296e9b673d:9aa2e57e955686acec794bae69d97767e08e302e57b7df3dad3c1a42a79def6421495a31fceb10cff265ee468e247d608437a7d3592423e770aba9cfdc4972276751711796646f77973e129f98494abe334d87943bc9c1bf64799b29ce31fc9450df22e87127c9bbbe0944b62b7cfc50c3a74725c6cc7220215baa48dab107",
     "LOBECHAT_AIPROVIDER_OPENROUTER_KEY_VAULTS", None, False, False),
    ("lobechat/V2__baseline_seed.sql",
     "814dac6a4cc5ddd40746b6f8:7a529e880c0dd36680b3248fbb0bd461:563c473227993bcdbe0283cea9162dec852626e46d985d0f0740740bf65e955b0ad7de33baf71886603a8ad6b90a783a7307bdd2ae",
     "LOBECHAT_AIPROVIDER_VLLM_KEY_VAULTS", None, False, False),
]


def load_env() -> dict[str, str]:
    env: dict[str, str] = {}
    if ENV_FILE.exists():
        for line in ENV_FILE.read_text().splitlines():
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, _, v = line.partition("=")
            env[k.strip()] = v.strip()
    return env


def append_env(name: str, value: str, b64: bool) -> None:
    env = load_env()
    if name in env:
        return
    stored = base64.b64encode(value.encode()).decode() if b64 else value
    suffix = "_B64" if b64 else ""
    line = f"{name}{suffix}={stored}\n"
    with ENV_FILE.open("a") as f:
        f.write(line)


def scrub_file(path: Path, pattern: str, placeholder: str,
               literal_value: str | None, is_regex: bool, is_b64: bool) -> bool:
    content = path.read_text()
    # Placeholder in SQL never carries _B64 suffix — render.py decodes _B64
    # vars from .env.flyway and exposes them under the non-suffixed name.
    marker = "${" + placeholder + "}"
    if marker in content:
        return False  # already scrubbed

    if is_regex:
        m = re.search(pattern, content)
        if not m:
            return False
        # If pattern has 3 groups, group 2 is the secret; else whole match.
        if m.lastindex and m.lastindex >= 2:
            real = m.group(2)
            new_content = content[:m.start(2)] + marker + content[m.end(2):]
        else:
            real = m.group(0)
            new_content = content[:m.start()] + marker + content[m.end():]
    else:
        if pattern not in content:
            return False
        real = literal_value if literal_value is not None else pattern
        # If pattern is a quoted literal like 'pswd123', keep quotes around marker
        if pattern.startswith("'") and pattern.endswith("'"):
            new_content = content.replace(pattern, "'" + marker + "'")
        else:
            new_content = content.replace(pattern, marker)

    append_env(placeholder, real, is_b64)
    path.write_text(new_content)
    return True


def main() -> int:
    if not ENV_FILE.exists():
        ENV_FILE.touch()
        ENV_FILE.write_text("# Flyway provisioning secrets — DO NOT COMMIT\n")

    changed_any = False
    for rel, pat, name, lit, is_re, is_b64 in SCRUB_RULES:
        path = ROOT / rel
        if not path.exists():
            print(f"skip (missing): {rel}", file=sys.stderr)
            continue
        if scrub_file(path, pat, name, lit, is_re, is_b64):
            print(f"scrubbed: {rel} -> ${{{name}{'_B64' if is_b64 else ''}}}")
            changed_any = True
        else:
            print(f"already scrubbed or not found: {rel} :: {name}")

    if not changed_any:
        print("no changes (idempotent run)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
