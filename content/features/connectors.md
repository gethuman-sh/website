---
title: "Connect Claude Code to Jira, Linear, GitHub, Notion, Figma and More"
sidebar_title: "Connectors"
weight: 2
description: "Connect Claude Code to Jira, GitHub, GitLab, Linear, Azure DevOps, Shortcut, ClickUp, Notion, Figma, Amplitude, and Sentry. One CLI, same commands, 95% fewer tokens than MCP servers. Credentials never touch the AI."
subtitle: "One CLI connects Claude Code to every tool your team uses — issue trackers, docs, designs, and analytics. 95% fewer tokens than MCP servers. Credentials never touch the AI."
docs_link: /docs/connectors/
---

human is the intent layer of the [dark software factory](/) — the thing that feeds your Claude Code agent real context from every tool your team uses. Without it, Claude can't see your Jira tickets, read your Notion docs, or inspect your Figma designs, and you become the bottleneck copying context between tools and the AI.

## The problem with connecting AI agents to your tools

Claude Code is powerful, but it can't see your Jira tickets, read your Notion docs, inspect your Figma designs, or check your Amplitude dashboards. Without these connections, you're the bottleneck — copying and pasting context between tools and the AI.

MCP servers exist for some of these, but each one is a separate install, a separate config, a separate set of credentials to manage. They dump raw API responses into your context window, burning through tokens. And half of them don't work in devcontainers.

## One install, every connector

human ships with built-in connectors for the tools development teams actually use:

**Issue Trackers**
- **Jira** — Jira Cloud and Server
- **GitHub** — GitHub Issues and Projects
- **GitLab** — GitLab Issues
- **Linear** — Linear issues and projects
- **Azure DevOps** — Azure Boards work items
- **Shortcut** — Shortcut stories
- **ClickUp** — ClickUp tasks

**Docs & Knowledge**
- **Notion** — Search workspace, read pages, query databases
- **ClickUp** — ClickUp Docs, wikis, and knowledge base

**Design**
- **Figma** — Files, components, comments, export

**Analytics**
- **Amplitude** — Events, funnels, retention, cohorts
- **Sentry** — Error tracking, issues, events

Every connector uses the same CLI patterns. Learn one, use them all.

## Same commands, every tracker

All issue tracker connectors share identical command structures:

```bash
# List issues
human jira issues list --project=KAN
human github issues list --project=octocat/hello-world
human linear issues list --project=ENG
human clickup issues list --project=901234567

# Get a single issue
human jira issue get KAN-1

# Create an issue
human linear issue create --project=ENG "Implement feature"

# Add a comment
human jira issue comment add KAN-1 "This is done"
```

Switch trackers without relearning commands. Your CLAUDE.md instructions work across projects regardless of which tracker they use.

## Just ask Claude

You don't need to memorize commands. Just tell Claude what you need:

```
> With human, get me the details of PROJ-123 from Jira

> With human, what are all the open tickets assigned to me
  in the ENG project on Linear?

> With human, what are the latest comments on the Figma
  file for the checkout redesign?
```

Add `human` to your `CLAUDE.md` and you won't need "With human" in every prompt.

## 95% fewer tokens than MCP servers

MCP servers dump raw API responses into your context window. A single Jira ticket can consume thousands of tokens of metadata Claude doesn't need.

human extracts signal and discards noise. The same 3 Jira tickets that cost 5,781 tokens via the raw API cost just 267 tokens through human — a 95% reduction. With `--table` format, it drops to 82 tokens.

That means you hit your daily token limit at 5pm instead of by lunch.

## Credentials never touch the AI

API tokens, passwords, and OAuth credentials are stored on your machine and used by the CLI. Claude Code never sees them — it just asks human to run commands, and human handles authentication.

In devcontainer setups, credentials stay on the host machine. The daemon forwards CLI commands from the container to the host, so secrets never cross the container boundary.

## Works in devcontainers

Every connector works transparently inside devcontainers. Start the daemon on the host, set the environment variables in your container, and all commands work as if you're running locally:

```bash
# On the host
human daemon start

# In the container — works exactly the same
human jira issues list --project=KAN
human notion search "quarterly report"
human figma file get ABC123
```

No extra configuration. No workarounds. The daemon handles it.

## Supported Claude Code integrations

### Claude Code Jira integration

Read, create, edit, comment, and transition Jira Cloud and Server issues directly from Claude Code. Supports custom fields, sprints, and JQL queries. Credentials stay on the host machine.

### Claude Code Linear integration

List, create, update, and comment on Linear issues and projects. Works with workspaces, teams, and labels. Same command structure as every other tracker.

### Claude Code GitHub Issues integration

Read and manage GitHub Issues and Projects from inside Claude Code. Works alongside the `gh` CLI, but returns tighter JSON so you burn fewer tokens on each issue read.

### Claude Code GitLab integration

Full GitLab Issues support — list, create, edit, comment, close. Works with self-hosted GitLab instances and gitlab.com alike.

### Claude Code Notion integration

Search your entire Notion workspace, read pages, and query databases. Perfect for letting Claude Code pull specs, design docs, and runbooks into its context without copy-paste.

### Claude Code Figma integration

Read Figma files, inspect components, and pull comments and exports. Enables design-to-code workflows where Claude reads the actual design, not a screenshot.

### Claude Code Amplitude and Sentry integration

Query Amplitude events, funnels, cohorts, and retention curves. Fetch Sentry issues and events. Data-driven development where Claude sees the real analytics and error data, not your hand-summarized version.

### Claude Code Azure DevOps, Shortcut, and ClickUp integrations

Full support for Azure Boards work items, Shortcut stories, and ClickUp tasks — all with the same `human {tracker} issues list` command structure.
