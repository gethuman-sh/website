---
title: GitLab
weight: 3
---

Connect to GitLab Issues.

## Configuration

```yaml
tracker: gitlab
gitlab:
  project: mygroup/myproject
  url: https://gitlab.com
  token_env: GITLAB_TOKEN
```

## Commands

```bash
# List issues
human gitlab issues list --project=mygroup/myproject

# Get a single issue
human gitlab issue get 42

# Create an issue
human gitlab issue create --project=mygroup/myproject "Add dark mode"

# Add a comment
human gitlab issue comment add 42 "Implemented in MR !15"
```
