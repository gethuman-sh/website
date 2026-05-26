---
title: /human-review
weight: 4
---

Reviews the current branch's changes against the ticket's acceptance criteria.

## Usage

```
/human-review <ticket-key>
```

## How it works

1. Fetches the ticket via `human <tracker> issue get <key>`
2. Loads the plan from `.human/plans/<key>.md` if it exists (for additional context)
3. Diffs the current branch against the default branch (`git diff <default>...HEAD`)
4. Evaluates the diff against each acceptance criterion from the ticket
5. Flags missing criteria, scope creep, and unhandled edge cases
6. Writes the review to `.human/reviews/<key>.md`

## Output format

```markdown
# Review: <TICKET_KEY>

## Summary
<one-line verdict: pass, pass with notes, or fail>

## Acceptance Criteria

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | <criterion from ticket> | PASS/FAIL | <file:line references> |

## Findings

### Missing criteria
- <acceptance criteria not addressed in the diff>

### Scope creep
- <changes in the diff not related to the ticket>

### Edge cases
- <unhandled edge cases>

## Test Results
<output of test run>
```

## Output location

`.human/reviews/<key>.md`

## What comes next

If the review passes, the ticket is ready to ship. If it fails, address the findings and run `/human-review` again.
