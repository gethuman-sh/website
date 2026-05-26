---
title: "Telegram Bot Messages for Claude Code"
sidebar_title: "Telegram"
weight: 8
description: "Let Claude Code read and acknowledge Telegram bot messages. Poll for user requests, process them in automation workflows, and close the loop — all from the CLI."
subtitle: "Claude Code can read Telegram bot messages, process user requests, and acknowledge them — turning a Telegram bot into a task inbox for your AI agent."
docs_link: /docs/connectors/
---

## Use Telegram as a task inbox for Claude Code

You set up a Telegram bot for your team or users. Messages come in — feature requests, bug reports, questions. Someone has to read them, triage them, and act on them.

With human, Claude Code can do that. It polls the bot for pending messages, reads them, acts on them, and acknowledges them when done.

## Three commands

```bash
# See what's waiting
human telegram list --table

# Read a specific message
human telegram get 123456

# Mark as handled
human telegram ack 123456
```

That's the full API. List, read, acknowledge.

## Filter by user

Restrict which Telegram users the bot listens to:

```yaml
telegrams:
  - name: support
    allowed_users: [123456789, 987654321]
```

Messages from other users are silently filtered out of `list` and `get` results.

## Configure in seconds

Add to `.humanconfig.yaml`:

```yaml
telegrams:
  - name: support
    description: "User feedback bot"
```

Set the token:

```bash
export TELEGRAM_SUPPORT_TOKEN=123456:ABC...
```

## Works in devcontainers

Like every other connector, the bot token stays on the host. The daemon forwards commands from the container — the agent never sees credentials.

```bash
# Inside the container
human telegram list --table
```
