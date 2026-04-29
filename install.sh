#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="${OPENCLAW_TOOLS_DIR:-$HOME/.openclaw/tools}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
STATE_DIR="${OPENCLAW_WORK_AGENT_DIR:-$HOME/.openclaw/work-agent}"
SKILLS_DIR="$WORKSPACE_DIR/skills"

mkdir -p "$TOOLS_DIR" "$STATE_DIR" "$SKILLS_DIR"

install -m 755 "$ROOT/bin/openclaw-work-agent" "$TOOLS_DIR/openclaw-work-agent"
rm -rf "$SKILLS_DIR/work-agent"
mkdir -p "$SKILLS_DIR/work-agent"
install -m 644 "$ROOT/skills/work-agent/SKILL.md" "$SKILLS_DIR/work-agent/SKILL.md"

if [[ ! -f "$STATE_DIR/config.json" ]]; then
  "$TOOLS_DIR/openclaw-work-agent" init --from "$ROOT/examples/company-profile.example.json" --yes
fi

AGENTS_MD="$WORKSPACE_DIR/AGENTS.md"
TOOLS_MD="$WORKSPACE_DIR/TOOLS.md"

if [[ -f "$AGENTS_MD" ]] && ! grep -q "### OpenClaw Work Agent" "$AGENTS_MD"; then
  cat >> "$AGENTS_MD" <<'EOF'

### OpenClaw Work Agent

When the user starts a message with `/work` or asks for the company/work agent, use:

```bash
~/.openclaw/tools/openclaw-work-agent <command>
```

Command mapping:

- `/work init` -> `openclaw-work-agent init`
- `/work status` -> `openclaw-work-agent status`
- `/work run` -> `openclaw-work-agent run`
- `/work run --dry-run` -> `openclaw-work-agent run --dry-run`
- `/work ask <question>` -> `openclaw-work-agent ask "<question>"`
- `/work mode ask` -> `openclaw-work-agent mode ask`
- `/work mode full` -> `openclaw-work-agent mode full`
- `/work cron install` -> `openclaw-work-agent cron install`

Default behavior is ask-then-execute. Even in full-access mode, ask before sending emails/messages, deleting data, replacing database subtrees, deploying, creating external resources, or changing payment/ad-spend settings.
EOF
fi

if [[ -f "$TOOLS_MD" ]] && ! grep -q "### OpenClaw Work Agent" "$TOOLS_MD"; then
  cat >> "$TOOLS_MD" <<'EOF'

### OpenClaw Work Agent

- CLI: `~/.openclaw/tools/openclaw-work-agent`
- Runtime config: `~/.openclaw/work-agent/config.json`
- Reports: configured company Obsidian folder, or `~/.openclaw/work-agent/reports`
- Main commands:
  - `openclaw-work-agent status`
  - `openclaw-work-agent run --dry-run`
  - `openclaw-work-agent mode ask|full`
  - `openclaw-work-agent cron install`
EOF
fi

cat <<EOF
Installed OpenClaw Work Agent.

CLI:
  $TOOLS_DIR/openclaw-work-agent

Skill:
  $SKILLS_DIR/work-agent/SKILL.md

Config:
  $STATE_DIR/config.json

Next:
  openclaw-work-agent status
  openclaw-work-agent run --dry-run
EOF
