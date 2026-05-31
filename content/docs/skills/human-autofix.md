---
title: /human-autofix
weight: 6.5
---

Runs the full bug-fix pipeline autonomously, end to end, pointed at a bug ticket — triage, plan, test-first fix, verify, and open a pull request. No user interaction.

## Usage

```
/human-autofix <BUG_KEY>
```

## How it works

1. **Triage & reproduce** — fetches the bug ticket, reproduces it, and reaches a verdict: `confirmed`, `not-a-bug`, or `undetermined`.
2. **Verdict gate** — only confirmed bugs proceed. `not-a-bug` and `undetermined` are closed or left as-is and produce no code changes.
3. **Plan** — writes a regression-test-first implementation plan and creates a linked engineering ticket.
4. **Test-first fix** — opens a feature branch `autofix/<eng-key>`, adds a failing regression test, then makes the root-cause fix until the suite is green, and pushes.
5. **Verify** — confirms the regression test fails before the fix and passes after, with the full suite green — a "done done" gate.
6. **Open PR & hand off** — runs `human pr create` (forge and repo derived from the git origin remote) and posts a `[human:ready-for-review]` handoff comment on the tracker carrying the PR URL.

Only bugs that are both **confirmed and verified** ever open a pull request.

## Audit trail

The entire run is recorded on the issue tracker, so the chain is traceable end to end:

```
bug comment → engineering ticket → pull request
```

`/human-autofix` is fully autonomous and will not claim success unless the test suite is green and the PR has opened.

## What comes next

The PR is handed off for human review via the `[human:ready-for-review]` comment. You review the outcome — the diff, the regression test, and the green suite — not every step that led there.
