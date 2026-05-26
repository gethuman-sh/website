---
title: Figma
weight: 8
---

Connect to Figma — browse files, inspect components, read comments, export assets.

## Configuration

```yaml
figma:
  token_env: FIGMA_TOKEN
```

## Commands

```bash
# Get a file
human figma file get <file-key>

# List comments
human figma file comments <file-key>

# List components
human figma file components <file-key>
```

The output includes component structure, styles, and design tokens in a text format that AI agents can consume directly.
