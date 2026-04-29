# OpenClaw Ops Brain

Reusable OpenClaw add-on for a `/work` company agent. The public product name is **OpenClaw Ops Brain**; the repo and CLI remain `openclaw-work-agent` for compatibility.

It gives OpenClaw a company operating layer that can:

- install a named Ops Brain agent profile for OpenClaw
- ask one plain-English onboarding question at a time
- build a company operating map across customers, product surfaces, workflows, growth, risks, and decision rules
- detect connected company sources
- keep a local company profile
- write Obsidian-backed work reports into a dedicated work-only vault
- monitor business and ops signals on a schedule
- learn from every completed work task and write faster playbooks for next time
- suggest automations and skills from repeated work
- support default ask-then-execute mode and explicit full-access mode

This repo is safe to publish. It contains only sample config and setup docs. Live company config, reports, logs, tokens, Gmail exports, Firebase data, and local state are excluded by `.gitignore`.

## What It Connects To

Ops Brain is connector-agnostic. It can work with anything OpenClaw can reach through an MCP, OAuth connector, CLI, local repo, API token, or a short setup plan.

Typical sources include:

- databases: Firebase, Postgres, MySQL, MongoDB, Supabase, Redis, internal APIs
- backend and infra: Cloud Functions, server logs, deploy providers, Sentry, Datadog, AWS/GCP/Render/Railway/Vercel/Netlify
- communication: Gmail, Outlook, Slack, Discord, Teams, Telegram, support desks
- product and growth: analytics, PostHog, Mixpanel, GA4, Meta Ads, Google Ads, app stores
- business systems: Stripe, Razorpay, billing, CRM, spreadsheets, docs, Drive, Notion, Confluence, Obsidian
- code and shipping: GitHub, GitLab, local repos, CI, release logs

During onboarding it asks what else you want connected. If a source is not connected yet, it reports that honestly and gives the shortest setup path: what connector/API/MCP to add, what credentials or auth are needed, what data to read, and which write actions must require approval.

## Install

```bash
git clone https://github.com/uphomesco-hub/openclaw-work-agent.git
cd openclaw-work-agent
./install.sh
```

This installs:

```text
~/.openclaw/tools/openclaw-work-agent
~/.openclaw/workspace/agents/work-agent.md
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

## Plain-English Use

The user-facing workflow is only:

```text
/work
```

OpenClaw handles the internal CLI calls. If onboarding is incomplete, it asks one plain-English question at a time and stores the answer. After onboarding is complete, `/work` shows what it understands and the user can continue in plain English.

Internal commands exist for setup scripts and debugging, but the user should not need them.

After onboarding, `/work` should combine:

- company profile and goals
- customers, product surfaces, critical workflows, growth channels, risks, and decision rules
- connected company sources across database, backend, mail, docs, chat, repos, analytics, payments, ads, and MCPs
- website URL and local/GitHub repo context
- latest commit/push and local change state
- latest blog/review content from the website repo when configured
- OpenClaw brain checks for live users, product activity, support/feedback, backend errors, content/repo changes, growth signals, and improvement ideas

The CLI is only the local memory and signal collector. OpenClaw is the brain. Once the setup questions are answered, OpenClaw should use the installed agent profile at `~/.openclaw/workspace/agents/work-agent.md` and inspect connected tools before forming the live company snapshot.

## Closed Loop Learning

Ops Brain improves itself after work is done. For every meaningful task, OpenClaw can internally record:

- what was done
- which tools, MCPs, files, repos, or sources were useful
- what was slow or repetitive
- what should be faster next time
- whether the task should become a reusable skill or workflow

The learning loop writes to the work-only Obsidian vault:

```text
wiki/syntheses/ops-brain-learning.md
wiki/playbooks/ops-brain-playbooks.md
```

Internal command:

```bash
~/.openclaw/tools/openclaw-work-agent learn --task "..." --result "..." --sources "..." --steps "..." --slow "..." --faster "..." --next "..."
```

The user should not need to run this. `/work` should remember useful paths, check prior playbooks before repeating work, and suggest better automations when repeated tasks appear.

## Light Monitor, Deep Report, And Candidate Signals

`Ops Brain Light Monitor` is the frequent OpenClaw brain loop. It runs every 30 minutes, asks the CLI to collect signals, then OpenClaw reasons over those signals using company context, connected tools, and the work vault. It only notifies when action is required.

`Ops Brain Daily Deep Report` is the daily synthesis. It runs at 09:15 Asia/Kolkata, writes the work-vault report, then OpenClaw should summarize context, repeated issues, automation candidates, and suggested next thresholds.

V1 includes configurable important-mail thresholds. These are candidate generators, not the brain:

```json
{
  "gmailImportant": {
    "enabled": true,
    "lookback": "1d",
    "maxResults": 10,
    "notifyOnCount": 1,
    "queryTerms": ["feedback", "bug", "refund", "not working"]
  }
}
```

The Gmail check first asks Gmail for likely messages, then filters locally by configured terms. OpenClaw should then semantically judge the candidate message before it suggests action or updates the work brain.

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

The installer or OpenClaw can create scheduled checks internally:

- `Ops Brain Urgent Watch`: every 2 minutes for high-signal mail/support/emergency findings
- `Ops Brain Light Monitor`: every 30 minutes
- `Ops Brain Daily Deep Report`: daily at 09:15 Asia/Kolkata

Scheduled runs are quiet by default. Reports are written to the configured Obsidian company folder. Telegram is used for concise notifications when configured and when a run is not quiet.

Urgent watch is near-instant polling, not true webhook push. With the default 2-minute interval, a new important Gmail/support message should usually be detected within a couple of minutes. True instant delivery requires source-specific webhooks such as Gmail push/watch.

For reliable near-instant local checks on macOS, install the LaunchAgent watcher:

```bash
./launchd/install-urgent-watch.sh
```

It runs `openclaw-work-agent run --scheduled urgent` every 120 seconds and logs under `~/.openclaw/work-agent/logs/`.

For scheduled runs, Telegram is sent only when connected sources produce a real finding or threshold says action is required. Missing connectors are setup context only; they stay in reports/status output and do not trigger alerts. Manual `run` commands also stay local unless `--notify` is explicitly passed.

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
git status --short
```

Also scan for private values:

```bash
grep -RInE 'botToken|refresh_token|client_secret|private_key|AIza|gho_|firebase-admin|service-account' . --exclude-dir=.git
```

The scan should only find docs or placeholder text, never live credentials.
