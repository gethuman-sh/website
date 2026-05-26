---
title: ClickUp
weight: 7
---

Connect to ClickUp tasks.

## Configuration

Add a `clickups:` section to your `.humanconfig.yaml`:

```yaml
clickups:
  - name: work
    token: pk_12345678_ABCDEFG
    team_id: "1234567"  # optional, for custom task IDs
    projects:
      - "901234567"     # List IDs
```

| Field | Description |
|-------|-------------|
| `name` | Instance name, used with `--tracker=<name>` when multiple trackers are configured |
| `token` | ClickUp personal API token (`pk_...`). Can also be set via `CLICKUP_TOKEN` or `CLICKUP_{NAME}_TOKEN` env var |
| `team_id` | Optional. Workspace ID, required when using custom task IDs (e.g. `PREFIX-123`) |
| `projects` | Optional. List of ClickUp List IDs to index |
| `url` | Optional. API base URL, defaults to `https://api.clickup.com/api` |
| `safe` | Optional. When `true`, blocks destructive operations (deletes) |

ClickUp organizes work as Workspace > Space > Folder > List > Task. The `--project` flag maps to a List ID.

## Authentication

ClickUp uses a personal API token passed in the raw `Authorization` header (not Bearer).

Generate your token at: **ClickUp Settings > Apps > API Token**

## Environment Variables

| Variable | Description |
|----------|-------------|
| `CLICKUP_TOKEN` | Global ClickUp API token |
| `CLICKUP_{NAME}_TOKEN` | Instance-specific token (e.g. `CLICKUP_WORK_TOKEN`) |
| `CLICKUP_URL` | Global API base URL override |
| `CLICKUP_{NAME}_URL` | Instance-specific URL override |
| `CLICKUP_TEAM_ID` | Global workspace ID |
| `CLICKUP_{NAME}_TEAM_ID` | Instance-specific workspace ID |

## CLI Flag

Create an ad-hoc ClickUp instance without config file:

```bash
human --clickup-token=pk_12345678_ABCDEFG clickup issue get abc123
```

## Commands

```bash
# List tasks in a list
human clickup issues list --project=901234567

# Get a single task
human clickup issue get abc123

# Get a task by custom ID (requires team_id in config)
human clickup issue get PROJ-42

# Create a task
human clickup issue create --project=901234567 "Fix login bug"

# Edit a task
human clickup issue edit abc123 --title="Updated title"

# Delete a task
human clickup issue delete abc123

# Transition task status
human clickup issue status abc123 "in progress"

# Start a task (transition + assign to yourself)
human clickup issue start abc123

# List available statuses
human clickup issue statuses abc123

# Add a comment
human clickup issue comment add abc123 "This is fixed in PR #42"

# List comments
human clickup issue comment list abc123
```

## Workspace Browsing

ClickUp organizes work as Workspace > Space > Folder > List > Task. Use these commands to discover your List IDs:

```bash
# List spaces (requires team_id in config)
human clickup spaces
human clickup spaces --table

# List folders in a space
human clickup folders --space SPACE_ID

# List lists in a folder
human clickup lists --folder FOLDER_ID

# List folderless lists in a space
human clickup lists --space SPACE_ID
```

## Members

```bash
# List workspace members (requires team_id in config)
human clickup members
human clickup members --table
```

Member IDs can be used with `human clickup issue start` or assignment operations.

## Subtasks

Create subtasks by specifying a parent task key:

```bash
human clickup issue create --project=901234567 "Subtask title" --parent=PARENT_TASK_ID
```

Subtask relationships are shown when getting a task via `human clickup issue get`.

## Custom Fields

```bash
# List custom field values on a task
human clickup fields abc123
human clickup fields abc123 --table

# Set a custom field value
human clickup field-set abc123 FIELD_ID "new value"
```

## Labels

Task tags/labels are returned in issue listings and get operations. They appear in the `labels` field of the JSON output.

## Linking PRs and Commits

Link GitHub pull requests and commits to ClickUp tasks. Links are stored in the task description with deduplication — running the same command again updates the existing entry.

The task ID is auto-detected from the current git branch name (e.g. `CU-abc123-fix` or `PROJ-42-feature`). Use `--task` to override.

```bash
# Link the current branch's PR to the auto-detected task
human clickup link pr

# Link a specific PR
human clickup link pr 42 --task abc123

# Link with explicit repo
human clickup link pr 42 --task abc123 --repo owner/repo

# Link the HEAD commit
human clickup link commit

# Link a specific commit
human clickup link commit abc1234 --task abc123

# Link with explicit repo (for commit URL)
human clickup link commit abc1234 --task abc123 --repo owner/repo
```

Requires `git` and `gh` (GitHub CLI) to be installed and authenticated.

## Task IDs

ClickUp tasks have alphanumeric IDs (e.g. `86a2w4xxz`). Workspaces can also enable custom task IDs with a prefix format like `PREFIX-123`.

To use custom task IDs, set `team_id` in your config. When `team_id` is configured, `human` automatically detects keys matching the `PREFIX-123` pattern and includes the required query parameters.

## Status Mapping

ClickUp statuses are per-List (not global). The status types map to `human`'s status categories:

| ClickUp Type | human Status Type |
|-------------|-------------------|
| `open` | `unstarted` |
| `custom` | `started` |
| `done` | `done` |
| `closed` | `done` |
