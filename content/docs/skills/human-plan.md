---
title: /human-plan
weight: 2
---

Fetches a ticket, explores the codebase, and produces a structured implementation plan.

## Usage

```
/human-plan <ticket-key>
```

## How it works

1. Fetches the ticket via `human <tracker> issue get <key>`
2. Explores the codebase with Grep, Glob, and Read to understand affected areas
3. Identifies existing patterns, conventions, and related code
4. Produces a structured plan with context, changes, and verification steps
5. Verifies that every file, function, and type referenced in the plan actually exists
6. Writes the plan to `.human/plans/<key>.md`
7. Creates a tracker ticket with the plan as its description

## Output format

```markdown
# Plan: <TICKET_KEY>

## Context
<ticket summary and acceptance criteria>

## Changes
1. `path/to/file.go` — <rationale for change>
2. `path/to/other.go` — <rationale>
...

## Verification
- <test commands to run>
- <manual checks>
- <edge cases to verify>
```

## Output location

`.human/plans/<key>.md`

## What comes next

Use [/human-execute](/docs/skills/human-execute/) to implement the plan step by step.
