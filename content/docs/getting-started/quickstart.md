---
title: Quick Start
weight: 2
---

Get up and running with human in under a minute.

## Install

The fastest way to install human:

```bash
curl -sSfL gethuman.sh/install.sh | bash
```

See [Installation](/docs/getting-started/installation/) for more options (Homebrew, mise, Go).

## Configure

Run the interactive setup wizard:

```bash
human init
```

This creates a `.humanconfig.yaml` in your project root. The wizard will:

1. Ask which issue tracker you use (Jira, GitHub, GitLab, Linear, Azure DevOps, Shortcut)
2. Prompt for your API token or credentials
3. Detect your project and set defaults
4. Optionally install Claude Code skills

## Your first command

List issues from your tracker:

```bash
# Jira
human jira issues list --project=KAN

# GitHub
human github issues list --project=octocat/hello-world

# Linear
human linear issues list --project=ENG
```

Get a single issue:

```bash
human jira issue get KAN-1
```

The output is optimized for AI consumption — structured, minimal, and focused on signal.

## Install skills

If you're using Claude Code, install the built-in lifecycle skills:

```bash
human install --agent claude
```

This gives your AI agent access to `/human-ready`, `/human-plan`, `/human-execute`, `/human-review`, and `/human-bug-plan`.

## Next steps

- [Configuration](/docs/getting-started/configuration/) — Fine-tune your `.humanconfig.yaml`
- [Connectors](/docs/connectors/) — Explore all supported services
- [Skills](/docs/skills/) — Learn about the lifecycle skills
