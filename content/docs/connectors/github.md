---
title: GitHub
weight: 2
---

Connect to GitHub Issues and Projects.

## Configuration

```yaml
tracker: github
github:
  project: octocat/hello-world
  token_env: GITHUB_TOKEN
```

## Commands

```bash
# List issues
human github issues list --project=octocat/hello-world

# Get a single issue
human github issue get 42

# Create an issue
human github issue create --project=octocat/hello-world "Fix login bug"

# Add a comment
human github issue comment add 42 "Fixed in PR #43"
```
