---
title: Policies
weight: 4
---

Policies give you fine-grained control over what AI agents can do with your issue trackers. Add a `policies:` section to your `.humanconfig.yaml` to define declarative rules that sit between the all-or-nothing `--safe` flag and full trust.

## Configuration

```yaml
policies:
  block:
    - delete
    - assign
  confirm:
    - transition:Done
    - create
```

### Actions

| Action | Behavior |
|--------|----------|
| `block` | The operation is rejected with an error. The inner tracker is never called. |
| `confirm` | A warning is logged to stderr before the operation proceeds. |
| *(unlisted)* | The operation is allowed without any warning. |

### Operations

Rules map to tracker provider methods:

| Rule string | Provider method | Category |
|-------------|-----------------|----------|
| `delete` | DeleteIssue | destructive |
| `create` | CreateIssue | write |
| `assign` | AssignIssue | write |
| `edit` | EditIssue | write |
| `comment` | AddComment | write |
| `transition` | TransitionIssue | write |

Read-only operations (ListIssues, GetIssue, ListComments, GetCurrentUser, ListStatuses) always pass through regardless of policy configuration.

### Parameterized rules

Rules can include an argument after a colon to match specific invocations:

```yaml
policies:
  block:
    - transition:Done    # block only transitions to "Done"
  confirm:
    - transition:Review  # warn before transitions to "Review"
```

A bare rule like `transition` matches all invocations of that operation. A parameterized rule like `transition:Done` matches only when the target status is "Done". Matching is case-insensitive.

## Examples

### Block all destructive operations

```yaml
policies:
  block:
    - delete
    - edit
    - assign
    - transition
```

### Confirm before completing tickets

```yaml
policies:
  confirm:
    - transition:Done
    - transition:Closed
```

### Log all write operations

```yaml
policies:
  confirm:
    - create
    - delete
    - edit
    - assign
    - comment
    - transition
```

## Interaction with --safe mode

The `--safe` flag (or `safe: true` on an instance) blocks `DeleteIssue` unconditionally via the SafeProvider. Policies are evaluated after safe mode in the wrapper chain:

```
raw provider -> SafeProvider (if --safe) -> PolicyProvider (if policies) -> AuditProvider
```

When both `--safe` and `policies.block: [delete]` are active, SafeProvider catches the delete first and PolicyProvider never sees it. The policy system extends safe mode to any operation -- you can block `assign`, `create`, `transition`, and more.

## Audit logging

Policy violations (both blocked and confirmed operations) are recorded in the audit log at `~/.human/audit.log`. Blocked operations appear as errors in the audit entries. This happens automatically because the AuditProvider wraps outside the PolicyProvider.

## Precedence

When the same operation appears in both `block` and `confirm` lists, `block` takes precedence. Unknown operation names in the policy config are silently ignored (they will never match, so all operations are allowed).
