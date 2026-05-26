---
title: Configuration
weight: 3
---

human is configured via a `.humanconfig.yaml` file in your project root. Run `human init` to create one interactively.

## Example

```yaml
tracker: jira
jira:
  url: https://yourcompany.atlassian.net
  project: KAN
  token_env: JIRA_API_TOKEN
  email: you@example.com
```

## Tracker options

| Field | Description |
|-------|-------------|
| `tracker` | Default tracker: `jira`, `github`, `gitlab`, `linear`, `azuredevops`, `shortcut`, `clickup` |

Each tracker has its own configuration block. See the individual [connector pages](/docs/connectors/) for details.

## Credentials

### 1Password (recommended)

Add a `vault` section and use `1pw://` references directly in your config:

```yaml
vault:
  provider: 1password
  account: my-account    # 1Password account name (top-left in app sidebar)

jiras:
  - name: work
    url: https://yourcompany.atlassian.net
    user: you@example.com
    key: 1pw://Development/Jira API Key/token
```

The 1Password desktop app must be installed and running. It will prompt for biometric or master password authentication. Enable "Integrate with other apps" in 1Password Settings > Developer.

### Environment variables

API tokens can also be set via environment variables:

```bash
export JIRA_API_TOKEN="your-token-here"
```

## Skills configuration

Skills are installed to your Claude Code configuration via:

```bash
human install --agent claude
```

This writes skill definitions to your project's `.claude/` directory.

## Policies

Control what agents can do with declarative rules. See [Policies](/docs/getting-started/policies/) for details.
