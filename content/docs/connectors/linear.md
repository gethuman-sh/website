---
title: Linear
weight: 4
---

Connect to Linear issues and projects.

## Configuration

```yaml
tracker: linear
linear:
  project: ENG
  token_env: LINEAR_API_KEY
```

## Commands

```bash
# List issues
human linear issues list --project=ENG

# Get a single issue
human linear issue get ENG-42

# Create an issue
human linear issue create --project=ENG "Implement feature"

# Add a comment
human linear issue comment add ENG-42 "Completed implementation"
```
