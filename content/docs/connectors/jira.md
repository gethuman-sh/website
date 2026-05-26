---
title: Jira
weight: 1
---

Connect to Jira Cloud or Jira Server.

## Configuration

```yaml
tracker: jira
jira:
  url: https://yourcompany.atlassian.net
  project: KAN
  token_env: JIRA_API_TOKEN
  email: you@example.com
```

| Field | Description |
|-------|-------------|
| `url` | Your Jira instance URL |
| `project` | Default project key |
| `token_env` | Environment variable containing your API token |
| `email` | Your Jira account email (required for Cloud) |

## Commands

```bash
# List issues in a project
human jira issues list --project=KAN

# Get a single issue with full details
human jira issue get KAN-1

# Create an issue
human jira issue create --project=KAN "Implement SSO"

# Add a comment
human jira issue comment add KAN-1 "This is done"

# List comments
human jira issue comments KAN-1

# Update issue status
human jira issue transition KAN-1 "In Progress"
```

## Output format

human returns only the fields relevant for development — title, status, description, acceptance criteria, and comments. The output is structured for AI consumption with minimal token usage.
