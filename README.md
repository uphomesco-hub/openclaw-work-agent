# OpenClaw Work Agent

Reusable OpenClaw add-on for a `/work` company agent.

It gives OpenClaw a company operating layer that can:

- detect connected company sources
- keep a local company profile
- write Obsidian-backed work reports into a dedicated work-only vault
- monitor business and ops signals on a schedule
- suggest automations and skills from repeated work
- support default ask-then-execute mode and explicit full-access mode

This repo is safe to publish. It contains only sample config and setup docs. Live company config, reports, logs, tokens, Gmail exports, Firebase data, and local state are excluded by `.gitignore`.

## What It Connects To

V1 supports these connector surfaces:

- OpenClaw MCP config, especially Firebase
- Google Workspace through `gog`
- Obsidian through `openclaw-obsidian` and `memory-wiki`
- Telegram through OpenClaw message delivery
- Meta Ads as a missing connector until an MCP/API integration is installed

The agent reports missing connectors honestly. It does not pretend to have data it cannot access.

## Install

```bash
git clone https://github.com/uphomesco-hub/openclaw-work-agent.git
cd openclaw-work-agent
./install.sh
```

This installs:

```text
~/.openclaw/tools/openclaw-work-agent
~/.openclaw/workspace/skills/work-agent/SKILL.md
~/.openclaw/work-agent/config.json
~/Documents/Obsidian-Work-Brain/
```

It also appends `/work` routing notes to the OpenClaw workspace `AGENTS.md` and `TOOLS.md` if those files exist.

## Configure

Interactive setup:

```bash
~/.openclaw/tools/openclaw-work-agent init
```

Use a sample profile:

```bash
~/.openclaw/tools/openclaw-work-agent init --from examples/company-profile.example.json --yes
```

The local config lives at:

```text
~/.openclaw/work-agent/config.json
```

Do not commit that file.

The dedicated work vault defaults to:

```text
~/Documents/Obsidian-Work-Brain
```

The CLI creates this wiki-style layout on first report:

```text
raw/
  sources/
  assets/
wiki/
  index.md
  log.md
  sources/
  concepts/
  entities/
  projects/
  questions/
  reports/
  syntheses/
```

## Commands

```bash
openclaw-work-agent status
openclaw-work-agent status --json
openclaw-work-agent run --dry-run
openclaw-work-agent run --notify
openclaw-work-agent ask "what do we know about refund handling?"
openclaw-work-agent mode ask
openclaw-work-agent mode full
openclaw-work-agent cron install
```

OpenClaw command mapping:

```text
/work init
/work status
/work run
/work run --dry-run
/work ask what changed in support this week?
/work mode ask
/work mode full
/work cron install
```

## Permission Model

Default mode is `ask`, meaning ask-then-execute.

`full` mode is available, but these actions still require exact confirmation:

- sending emails or external messages
- deleting records, files, users, apps, or projects
- replacing database subtrees or large data ranges
- deploying or initializing services
- creating external resources
- changing payment, pricing, subscription, or ad-spend settings

Confirmation should include the exact target, intended change, and likely impact.

## Always-On Loop

Install scheduled checks:

```bash
openclaw-work-agent cron install
```

This creates:

- `Work Agent Light Monitor`: every 30 minutes
- `Work Agent Daily Deep Report`: daily at 09:15 Asia/Kolkata

Scheduled runs are quiet by default. Reports are written to the configured Obsidian company folder. Telegram is used for concise notifications when configured and when a run is not quiet.

## UpHomes Validation Profile

`examples/uphomes.example.json` shows a sanitized version of the first validation profile:

- Firebase project: replace with your Firebase project ID
- Gmail account: replace with your Google Workspace account
- Obsidian folder: `~/Documents/Obsidian-Work-Brain/wiki/projects/uphomes-work-agent`
- Telegram target: replace with your OpenClaw Telegram chat ID

This file has no secrets. It is an example profile only.

## Public Repo Hygiene

Before publishing:

```bash
npm run check
openclaw-work-agent run --dry-run
git status --short
```

Also scan for private values:

```bash
grep -RInE 'botToken|refresh_token|client_secret|private_key|AIza|gho_|firebase-admin|service-account' . --exclude-dir=.git
```

The scan should only find docs or placeholder text, never live credentials.
