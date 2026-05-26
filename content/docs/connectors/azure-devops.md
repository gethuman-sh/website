---
title: Azure DevOps
weight: 5
---

Connect to Azure Boards work items.

## Configuration

```yaml
tracker: azuredevops
azuredevops:
  organization: myorg
  project: Human
  token_env: AZURE_DEVOPS_PAT
```

## Commands

```bash
# List work items
human azuredevops issues list --project=Human

# Get a single work item
human azuredevops issue get 42

# Create a work item
human azuredevops issue create --project=Human "Set up CI pipeline"

# Add a comment
human azuredevops issue comment add 42 "Pipeline configured"
```
