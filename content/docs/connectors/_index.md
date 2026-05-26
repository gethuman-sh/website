---
title: Connectors
weight: 3
---

Every connector uses the same CLI patterns. Learn one, use them all.

## Issue Trackers

- [Jira](/docs/connectors/jira/) — Jira Cloud and Server
- [GitHub](/docs/connectors/github/) — GitHub Issues and Projects
- [GitLab](/docs/connectors/gitlab/) — GitLab Issues
- [Linear](/docs/connectors/linear/) — Linear issues and projects
- [Azure DevOps](/docs/connectors/azure-devops/) — Azure Boards work items
- [Shortcut](/docs/connectors/shortcut/) — Shortcut stories
- [ClickUp](/docs/connectors/clickup/) — ClickUp tasks

## Docs & Knowledge

- [Notion](/docs/connectors/notion/) — Search workspace, read pages, query databases
- [ClickUp](/docs/connectors/clickup/) — ClickUp Docs, wikis, and knowledge base

## Design

- [Figma](/docs/connectors/figma/) — Files, components, comments, export

## Analytics

- [Amplitude](/docs/connectors/amplitude/) — Events, funnels, retention, cohorts
- [Sentry](/docs/connectors/sentry/) — Error tracking, issues, events

## Common patterns

All issue tracker connectors share the same command structure:

```bash
# List issues
human <tracker> issues list --project=<PROJECT>

# Get a single issue
human <tracker> issue get <ID>

# Create an issue
human <tracker> issue create --project=<PROJECT> "Title"

# Add a comment
human <tracker> issue comment add <ID> "Comment text"
```
