---
title: CLI Reference
weight: 1
---

## Global flags

| Flag | Description |
|------|-------------|
| `--help` | Show help for any command |
| `--version` | Print version |
| `--table` | Compact table format |

## Issue tracker commands

All issue trackers (`jira`, `github`, `gitlab`, `linear`, `azuredevops`, `shortcut`) share the same command structure:

### List issues

```bash
human <tracker> issues list --project=<PROJECT>
```

### Get an issue

```bash
human <tracker> issue get <ID>
```

### Create an issue

```bash
human <tracker> issue create --project=<PROJECT> "Title"
human <tracker> issue create --project=<PROJECT> "Title" --description "Detailed description"
```

### Add a comment

```bash
human <tracker> issue comment add <ID> "Comment text"
```

### List comments

```bash
human <tracker> issue comments <ID>
```

### Transition an issue

```bash
human <tracker> issue transition <ID> "Status"
```

## Shortcut commands

```bash
human get <KEY>                      # Get an issue (auto-detect tracker)
human list --project=<PROJECT>       # List issues (auto-detect tracker)
human tracker list                   # List configured trackers
```

These shortcut commands work when only one tracker type is configured. When multiple tracker types are configured, use the provider-specific commands.

## Notion commands

```bash
human notion search "query"
human notion page get <page-id>
```

## Figma commands

```bash
human figma file get <file-key>
human figma file comments <file-key>
human figma file components <file-key>
```

## Amplitude commands

```bash
human amplitude events list
human amplitude cohorts list
```

## Browser command

```bash
human browser <URL>
```

Opens a URL via the Chrome extension and returns page content.

## Daemon commands

```bash
human daemon start                    # Start the daemon
human daemon start --addr :8080       # Start on custom port
human daemon start --chrome-addr :9286  # Custom chrome proxy port
human daemon token                    # Print the current token
human daemon status                   # Check if daemon is reachable
human daemon status --addr host:port  # Check a specific address
```

## Chrome Bridge command

```bash
human chrome-bridge                  # Start in background
human chrome-bridge --foreground     # Start in foreground
```

## Setup commands

```bash
human init                    # Interactive setup wizard
human install --agent claude  # Install Claude Code skills
```

## Environment variables

| Variable | Description |
|----------|-------------|
| `HUMAN_DAEMON_ADDR` | Daemon address for container-to-host communication |
| `HUMAN_DAEMON_TOKEN` | Authentication token for daemon |
| `HUMAN_CHROME_ADDR` | Chrome proxy address for Chrome Bridge |
| `JIRA_API_TOKEN` | Jira API token |
| `GITHUB_TOKEN` | GitHub personal access token |
| `GITLAB_TOKEN` | GitLab personal access token |
| `LINEAR_API_KEY` | Linear API key |
| `AZURE_DEVOPS_PAT` | Azure DevOps personal access token |
| `SHORTCUT_API_TOKEN` | Shortcut API token |
| `NOTION_TOKEN` | Notion integration token |
| `FIGMA_TOKEN` | Figma personal access token |
| `AMPLITUDE_API_KEY` | Amplitude API key |
| `AMPLITUDE_SECRET_KEY` | Amplitude secret key |
