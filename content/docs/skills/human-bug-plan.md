---
title: /human-bug-plan
weight: 6
---

Analyzes a bug ticket for root cause, traces affected code, and produces a structured fix plan.

## Usage

```
/human-bug-plan <ticket-key>
```

## How it works

1. Fetches the bug ticket via `human <tracker> issue get <key>`
2. Fetches ticket comments via `human <tracker> issue comment list <key>` (comments often contain stack traces and error logs)
3. Identifies symptoms — error messages, stack traces, failing inputs, reproduction steps
4. Locates code via Grep and Glob — functions in stack traces, error message strings, related code paths, test files
5. Reads and traces the code flow to identify root cause
6. Writes the analysis to `.human/bugs/<key>.md`

## Output format

```markdown
# Bug Analysis: <TICKET_KEY>

## Summary
<one-line description of the bug>

## Symptoms
- <observable behaviors, error messages, failing conditions>

## Root Cause
<explanation referencing specific files and line numbers>

## Affected Code
| File | Lines | Role |
|------|-------|------|
| path/to/file.go | 42-58 | <what this code does in context> |

## Fix Plan
1. <ordered steps, each referencing specific files/functions>

## Test Plan
- <existing tests to update, new tests to add, manual checks>

## Related Code
- <other areas that may be affected>
```

## Output location

`.human/bugs/<key>.md`

## What comes next

Use [/human-execute](/docs/skills/human-execute/) to implement the fix plan. The executor loads bug analyses from `.human/bugs/` when no plan exists in `.human/plans/`.
