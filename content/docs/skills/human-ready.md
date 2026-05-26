---
title: /human-ready
weight: 1
---

Fetches a ticket from your issue tracker and evaluates it against a Definition of Ready checklist. Identifies gaps before development starts.

## Usage

```
/human-ready <ticket-key>
```

## How it works

1. Fetches the ticket via `human <tracker> issue get <key>`
2. Evaluates the ticket against 6 Definition of Ready criteria
3. Presents the assessment and asks you to fill in any gaps
4. Writes the completed assessment to `.human/ready/<key>.md`

## Criteria

Each criterion is marked as **present**, **partially present**, or **missing**:

| # | Criterion | What it checks |
|---|-----------|----------------|
| 1 | Clear description | Is the problem or feature clearly stated? |
| 2 | Acceptance criteria | Are there concrete, testable conditions for "done"? |
| 3 | Scope | Is the ticket small enough for a single implementation effort? |
| 4 | Dependencies | Are external dependencies or blockers identified? |
| 5 | Context | Is the "why" explained (user need, business reason)? |
| 6 | Edge cases | Are failure modes or boundary conditions mentioned? |

## Output format

```markdown
# Readiness: <TICKET_KEY>

## Summary
<one-line ticket summary>

## Definition of Ready assessment

| # | Criterion           | Status            | Notes                        |
|---|---------------------|-------------------|------------------------------|
| 1 | Clear description   | present/partial/missing | <what is or isn't clear>  |
| 2 | Acceptance criteria | present/partial/missing | <details>                 |
| 3 | Scope               | present/partial/missing | <details>                 |
| 4 | Dependencies        | present/partial/missing | <details>                 |
| 5 | Context             | present/partial/missing | <details>                 |
| 6 | Edge cases          | present/partial/missing | <details>                 |

## Missing information
<specific questions for each partial or missing criterion>
```

## Output location

`.human/ready/<key>.md`

## What comes next

Once all criteria are present, proceed to [/human-plan](/docs/skills/human-plan/) to create an implementation plan.
