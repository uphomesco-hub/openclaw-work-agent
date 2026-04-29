#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="${OPENCLAW_TOOLS_DIR:-$HOME/.openclaw/tools}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
STATE_DIR="${OPENCLAW_WORK_AGENT_DIR:-$HOME/.openclaw/work-agent}"
SKILLS_DIR="$WORKSPACE_DIR/skills"
AGENTS_DIR="$WORKSPACE_DIR/agents"

mkdir -p "$TOOLS_DIR" "$STATE_DIR" "$SKILLS_DIR" "$AGENTS_DIR"

install -m 755 "$ROOT/bin/openclaw-work-agent" "$TOOLS_DIR/openclaw-work-agent"
rm -rf "$SKILLS_DIR/work-agent"
mkdir -p "$SKILLS_DIR/work-agent"
install -m 644 "$ROOT/skills/work-agent/SKILL.md" "$SKILLS_DIR/work-agent/SKILL.md"
install -m 644 "$ROOT/agents/work-agent.md" "$AGENTS_DIR/work-agent.md"

if [[ ! -f "$STATE_DIR/config.json" ]]; then
  "$TOOLS_DIR/openclaw-work-agent" init --from "$ROOT/examples/company-profile.example.json" --yes
fi

AGENTS_MD="$WORKSPACE_DIR/AGENTS.md"
TOOLS_MD="$WORKSPACE_DIR/TOOLS.md"

if [[ -f "$AGENTS_MD" ]]; then
  TMP_AGENTS="$(mktemp)"
  sed -e '/### OpenClaw Work Agent/,/### End OpenClaw Work Agent/d' -e '/### OpenClaw Ops Brain/,/### End OpenClaw Ops Brain/d' "$AGENTS_MD" > "$TMP_AGENTS"
  cat "$TMP_AGENTS" > "$AGENTS_MD"
  rm -f "$TMP_AGENTS"
  cat >> "$AGENTS_MD" <<'EOF'

### OpenClaw Ops Brain

The only user-facing command is `/work`. Treat it as the OpenClaw Ops Brain agent, not a command menu.

When the user sends `/work` or asks to switch to work mode, run:

```bash
~/.openclaw/tools/openclaw-work-agent
```

If the CLI asks an onboarding question, treat the user's next plain-English reply as the answer and run:

```bash
~/.openclaw/tools/openclaw-work-agent answer "<full user reply>"
```

Do not make the user run setup/status/threshold/cron commands. Handle those internally. Once onboarding is complete, `/work` should summarize the company, connected sources, watched signals, permission mode, and work-vault location in plain English.

Use the installed agent profile for behavior and safety rules:

```text
~/.openclaw/workspace/agents/work-agent.md
```

If the CLI says onboarding is complete, do not stop there. Use OpenClaw brain/tool access to inspect connected sources when useful: Firebase, Gmail, Drive, Obsidian, website files, GitHub/local repos, Telegram, and any installed MCPs. Build a short live company snapshot before replying.

Do not notify the user just because an optional connector is missing. Missing connectors are setup context only. Telegram/background updates should contain connected-source findings, decisions needed, or urgent issues.

After meaningful work, update the closed-loop learning memory with:

```bash
~/.openclaw/tools/openclaw-work-agent learn --task "..." --result "..." --sources "..." --steps "..." --slow "..." --faster "..." --next "..."
```

Keep this internal. The user should only see that `/work` remembers prior work, reuses faster playbooks, and suggests better automations.

Default behavior is ask-then-execute. Even in full-access mode, ask before sending emails/messages, deleting data, replacing database subtrees, deploying, creating external resources, or changing payment/ad-spend settings.

### End OpenClaw Ops Brain
EOF
fi

if [[ -f "$TOOLS_MD" ]]; then
  TMP_TOOLS="$(mktemp)"
  sed -e '/### OpenClaw Work Agent/,/### End OpenClaw Work Agent/d' -e '/### OpenClaw Ops Brain/,/### End OpenClaw Ops Brain/d' "$TOOLS_MD" > "$TMP_TOOLS"
  cat "$TMP_TOOLS" > "$TOOLS_MD"
  rm -f "$TMP_TOOLS"
  cat >> "$TOOLS_MD" <<'EOF'

### OpenClaw Ops Brain

- CLI: `~/.openclaw/tools/openclaw-work-agent`
- Agent profile: `~/.openclaw/workspace/agents/work-agent.md`
- Runtime config: `~/.openclaw/work-agent/config.json`
- Reports: configured company Obsidian folder, or `~/.openclaw/work-agent/reports`
- User-facing entrypoint: `/work`
- Internal CLI entrypoint: `openclaw-work-agent`
- Internal onboarding answer handler: `openclaw-work-agent answer "<plain English answer>"`
- Internal learning handler: `openclaw-work-agent learn --task "..." --result "..." --faster "..."`

### End OpenClaw Ops Brain
EOF
fi

cat <<EOF
Installed OpenClaw Ops Brain.

CLI:
  $TOOLS_DIR/openclaw-work-agent

Skill:
  $SKILLS_DIR/work-agent/SKILL.md

Agent profile:
  $AGENTS_DIR/work-agent.md

Config:
  $STATE_DIR/config.json

Next in OpenClaw:
  /work
EOF
