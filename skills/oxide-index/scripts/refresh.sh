#!/usr/bin/env bash
# Refreshes the Oxide GitHub org repo index.
# Writes to ~/.claude/skills/oxide-index/oxide-repos.md

set -euo pipefail

TOKEN_FILE="$HOME/.config/oxide/gh-readonly-token"
OUT_FILE="$HOME/.claude/skills/oxide-index/oxide-repos.md"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "ERROR: Token file not found: $TOKEN_FILE" >&2
  echo "Create it with: echo 'github_pat_YOUR_TOKEN' > $TOKEN_FILE && chmod 600 $TOKEN_FILE" >&2
  exit 1
fi

export GH_TOKEN
GH_TOKEN="$(cat "$TOKEN_FILE")"

echo "Fetching oxidecomputer repo list..." >&2

gh repo list oxidecomputer --limit 1000 \
  --json name,description,primaryLanguage,updatedAt,isPrivate,isArchived,url,diskUsage,isFork \
  | python3 -c "
import sys, json, datetime

repos = json.load(sys.stdin)
out_path = sys.argv[1]

now = datetime.datetime.now(datetime.UTC)
generated = now.strftime('%Y-%m-%d %H:%M UTC')

active   = sorted([r for r in repos if not r.get('isArchived') and not r.get('isFork')],
                  key=lambda r: r.get('updatedAt', ''), reverse=True)
archived = sorted([r for r in repos if r.get('isArchived') and not r.get('isFork')],
                  key=lambda r: r.get('updatedAt', ''), reverse=True)
forks    = [r for r in repos if r.get('isFork')]

def fmt_lang(r):
    lang = r.get('primaryLanguage') or {}
    return lang.get('name', '') if isinstance(lang, dict) else str(lang)

def fmt_size(kb):
    if kb is None: return ''
    return f'{kb//1024}M' if kb >= 1024 else f'{kb}K'

def fmt_date(s):
    return s[:10] if s else ''

def row(r):
    vis  = 'private' if r.get('isPrivate') else 'public'
    desc = (r.get('description') or '').replace('|', '&#124;')[:80]
    return (f\"| [{r['name']}]({r['url']}) | {vis} | {fmt_lang(r)} \"
            f\"| {fmt_date(r.get('updatedAt'))} | {fmt_size(r.get('diskUsage'))} | {desc} |\")

arch = '''## Key Architecture Relationships

\`\`\`
Hardware / Firmware
  hubris           — RTOS for RoT (Root of Trust) microcontrollers (Cortex-M)
  hubtools          — Host-side tooling for hubris images
  dice-util         — RoT identity / attestation (DICE protocol)

Hypervisor / VMM
  propolis          — bhyve-based VMM; runs guest VMs on Oxide hardware
  omicron           — Control plane: Nexus (API), Sled Agent, internal services
  crucible          — Distributed block storage (used by propolis for VM disks)
  maghemite         — DDM routing daemon; manages inter-sled network fabric
  dendrite          — Sidecar ASIC control plane (switching/routing)

Developer-Facing
  oxide / oxide.rs  — Public Rust SDK + CLI wrapping the Oxide API
  console           — Web UI (React/TypeScript) for the Oxide rack
  docs-content      — Prose documentation source

Shared Libraries / Infra
  dropshot          — HTTP server framework (OpenAPI from Rust types)
  progenitor        — OpenAPI -> Rust client generator
  sled-hardware     — Hardware enumeration shared between omicron and hubris
  steno             — Sagas / distributed transaction library used in omicron
  oximeter          — Telemetry / metrics collection

Dependency Flow (simplified):
  hubris --> propolis --> crucible
                    +--> omicron --> oxide / console
\`\`\`
'''

lines = [
    '# Oxide Computer GitHub Org Index',
    '',
    f'Generated: {generated}  ',
    f'Active repos: {len(active)}  |  Archived: {len(archived)}  |  Forks: {len(forks)}',
    '',
    arch,
    f'## Active Repos ({len(active)})',
    '',
    '| Repo | Vis | Lang | Updated | Size | Description |',
    '|------|-----|------|---------|------|-------------|',
    *[row(r) for r in active],
    '',
    f'## Archived Repos ({len(archived)})',
    '',
    '| Repo | Vis | Lang | Updated | Size | Description |',
    '|------|-----|------|---------|------|-------------|',
    *[row(r) for r in archived],
]

if forks:
    lines += [
        '',
        f'## Forks ({len(forks)})',
        '',
        '| Repo | Vis | Lang | Updated | Size | Description |',
        '|------|-----|------|---------|------|-------------|',
        *[row(r) for r in forks],
    ]

with open(out_path, 'w') as f:
    f.write('\n'.join(lines) + '\n')

print(f'Written: {out_path}')
print(f'Active: {len(active)}, Archived: {len(archived)}, Forks: {len(forks)}')
" "$OUT_FILE"

echo "Done. Index saved to: $OUT_FILE" >&2
