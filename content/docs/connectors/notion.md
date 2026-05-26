---
title: Notion
weight: 7
---

Connect to Notion workspaces — search pages, read content, query databases.

## Configuration

```yaml
notion:
  token_env: NOTION_TOKEN
```

## Commands

```bash
# Search workspace
human notion search "quarterly report"

# Get a page
human notion page get <page-id>
```

Notion integration requires an internal integration token. Create one at [notion.so/my-integrations](https://www.notion.so/my-integrations) and share the relevant pages with it.
