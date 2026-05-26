---
title: /human-sprint
weight: 0.7
---

One command from rough idea to shipped code. Chains the full human pipeline — ideate, plan, execute, review — auto-deciding mechanical questions and surfacing only genuine taste decisions.

## Usage

```
/human-sprint <rough idea or topic>
```

Accepts a freeform idea (e.g. `"add webhook support for tracker events"`).

## How it works

1. **Pipeline depth**: Asks how far to go:
   - **Tickets only** — create PM ticket + engineering plan, then stop
   - **Plan + execute** — create tickets and implement
   - **Full pipeline** — create tickets, implement, and review

2. **Phase 1 — Ideate**: Runs the [/human-ideate](/docs/skills/human-ideate/) flow (forcing questions, scope decision, tracker choice), creates PM ticket

3. **Phase 2 — Plan**: Delegates to the planner agent, which reads the ideation artifact, explores the codebase, and creates an engineering ticket with implementation plan

4. **Mechanical decision gate**: Before executing, checks the plan for architecture choices. Mechanical decisions are auto-resolved. Taste decisions are surfaced for your input.

5. **Phase 3 — Execute**: Implements the plan step by step, runs a review checkpoint

6. **Phase 4 — Review**: Reviews changes against acceptance criteria, offers to fix issues

7. **Summary**: Presents the full traceability chain — PM ticket, eng ticket, commits, artifacts

## Decision principles

Mechanical questions are auto-decided using:

- **Narrowest wedge first** — choose the smallest scope that delivers value
- **Completeness within scope** — whatever is in scope should be complete
- **Explicit > clever** — prefer obvious solutions over abstractions
- **Reuse > reinvent** — use existing patterns before creating new ones
- **Bias toward action** — when in doubt, lean toward building

## Taste decisions (always ask you)

- Scope expansion vs. reduction
- Architecture choices with genuine tradeoffs
- When product and engineering perspectives conflict

## Traceability

Every sprint produces a full chain:

```
PM ticket    → created in your chosen tracker
Eng ticket   → created in Linear (or chosen eng tracker)
Commits      → reference both tickets
Artifacts    → .human/ideation/, .human/plans/, .human/reviews/
```

## Example

```
/human-sprint "add rate limiting to the API"

→ Forcing questions challenge the premise
→ PM ticket created in Shortcut: "Rate limiting for API endpoints"
→ Engineering plan created in Linear: HUM-44
→ Implementation: 3 files changed, 2 tests added
→ Review: all acceptance criteria pass
→ Summary with full traceability
```

## What comes next

The sprint is self-contained. The review phase serves as the final quality gate.
