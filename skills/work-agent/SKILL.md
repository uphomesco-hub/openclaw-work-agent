---
name: work-agent
description: Use when the user asks for /work, a company brain, startup operating agent, always-on business monitoring, connector setup for Firebase/Gmail/Drive/Obsidian/Meta Ads, or OpenClaw skills that understand and operate a company.
---

# Work Agent

This skill turns OpenClaw into a company operating agent. It uses installed MCPs, Google Workspace, Obsidian memory, Telegram alerts, and local tools to understand the company, monitor operations, and suggest or execute approved actions.

## Core Workflow

1. Internally inspect connector status with the Work Agent CLI when needed.
2. Use the company profile in `~/.openclaw/work-agent/config.json` as the operating context.
3. Use the dedicated work-only Obsidian vault reports and wiki pages as durable memory before answering strategic or historical questions.
4. Use MCPs, Gmail, GitHub/local repos, website files, and local skills for live data only when they are actually connected.
5. If a connector is missing, give setup steps instead of inventing data.
6. Save durable findings and recurring workflows into Obsidian.
7. Suggest a new skill when a task repeats.

## User Experience

The user should only need `/work`.

- `/work` enters work mode.
- If onboarding is incomplete, ask one plain-English question.
- Save each plain-English answer with the internal `answer` command.
- Do not ask completed onboarding questions again.
- Once onboarding is complete, summarize what the agent understands: company, goals, sources, watched signals, permission mode, and missing connectors.
- Include website URL, latest repo commits/push context, latest blogs/reviews, and product/content opportunities when configured.
- After that, all work-mode interaction should be normal plain English.

Internal commands exist for OpenClaw and setup scripts, but do not present them as the workflow unless the user asks for technical details.

## Permission Boundary

Default mode is ask-then-execute. Full-access mode is allowed only when explicitly enabled.

Always ask for exact confirmation before:

- Sending emails or external messages
- Deleting records, files, users, apps, or projects
- Replacing database subtrees or large data ranges
- Deploying or initializing services
- Creating external resources
- Changing payment, pricing, subscription, or ad-spend settings

Confirmation must include the exact target, intended change, and likely impact.

## Connector Notes

- Firebase: prefer OpenClaw MCP config; query live data through available Firebase MCP tools.
- Google Workspace: use `gog` for Gmail, Drive, Docs, Sheets, and Calendar.
- Obsidian: use `openclaw-obsidian` with the configured work vault path, defaulting to `~/Documents/Obsidian-Work-Brain`.
- Telegram: use OpenClaw message delivery for concise alerts.
- Meta Ads: treat as missing until an MCP/API connector is present.

## Report Style

Reports should be short, evidence-backed, and decision-oriented:

- What changed
- What looks wrong
- What needs a decision
- What can be automated next
- What source/tool was used

## Thresholds

Light monitor is the frequent brain loop. Deep report is the daily synthesis.

Use thresholds as candidate generators for:

- important Gmail/feedback detection
- backend error checks
- sudden activity changes
- repeated manual work that should become a skill

When a threshold fires, do not treat it as the final answer. Use OpenClaw reasoning and connected sources to decide whether it is actually important, update the work vault, and propose the next action. Do not send external replies or mutate production systems without the permission policy above.

## Engineering And Data Fixes

For Firebase, backend, database, Cloud Functions, or repository issues:

- Explain what appears wrong in plain English.
- Say whether it looks urgent.
- Offer "I can fix this if you want" when access exists.
- Offer "we should assign this to the dev team" when it should be reviewed or is outside current access.
- Ask before writing, deleting, deploying, sending messages, or changing production data.

## Live Work Summary

When `/work` is entered after onboarding, enrich the CLI summary with OpenClaw brain/tool checks:

- Firebase: online users from RTDB, users today, property/listing activity today, function/backend errors, and user behavior signals.
- Gmail: important feedback, leads, complaints, payment issues, and support messages.
- Website/content: latest blog and review seeds, what content is running, what topic might perform better, and SEO/conversion improvements.
- Repos/GitHub: latest commit/push, dirty local changes, branches, and whether a fix should be handled now or assigned.
- Obsidian: update the work brain with what was learned.

Keep the final user-facing answer plain English and decision-oriented.
