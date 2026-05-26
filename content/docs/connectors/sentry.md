---
title: Sentry
weight: 10
---

Connect to Sentry — error tracking, issue management, and event monitoring.

## Configuration

```yaml
sentry:
  organization: your-org-slug
  token_env: SENTRY_AUTH_TOKEN
```

## Commands

```bash
# List issues in a project
human sentry issues list --project=your-project

# Get a single issue with details
human sentry issue get 12345

# List events for an issue
human sentry issue events 12345

# Resolve an issue
human sentry issue resolve 12345

# Unresolve an issue
human sentry issue unresolve 12345
```

AI agents can query Sentry issues to investigate errors and triage bugs during development.
