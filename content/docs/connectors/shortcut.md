---
title: Shortcut
weight: 6
---

Connect to Shortcut stories.

## Configuration

```yaml
tracker: shortcut
shortcut:
  project: MyProject
  token_env: SHORTCUT_API_TOKEN
```

## Commands

```bash
# List stories
human shortcut issues list --project=MyProject

# Get a single story
human shortcut issue get 42

# Create a story
human shortcut issue create --project=MyProject "Add user onboarding"

# Add a comment
human shortcut issue comment add 42 "Onboarding flow complete"
```
