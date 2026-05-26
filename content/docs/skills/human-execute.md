---
title: /human-execute
weight: 3
---

Loads an implementation plan and executes it step by step, then runs a review checkpoint.

## Usage

```
/human-execute <ticket-key>
```

## How it works

1. Loads the plan from `.human/plans/<key>.md` (falls back to `.human/bugs/<key>.md` for bug fix plans)
2. Fetches the ticket via `human <tracker> issue get <key>` for original context
3. Parses the plan's changes section into ordered tasks
4. Executes each task sequentially:
   - Reads the target file before modifying it
   - Makes the change described in the plan
   - Verifies the change compiles/parses correctly
5. Runs a review checkpoint by invoking the [/human-review](/docs/skills/human-review/) agent
6. Runs a done checkpoint internally to verify completion
7. Reports: files created, files modified, review outcome, done verdict

## Prerequisites

A plan must exist at `.human/plans/<key>.md` or `.human/bugs/<key>.md`. If neither exists, run [/human-plan](/docs/skills/human-plan/) or [/human-bug-plan](/docs/skills/human-bug-plan/) first.

## What comes next

The executor automatically invokes review and done checkpoints. If the done verdict is NOT DONE, address the remaining items and re-run `/human-execute`.
