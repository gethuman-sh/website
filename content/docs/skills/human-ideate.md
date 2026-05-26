---
title: /human-ideate
weight: 0.5
---

Challenges your idea with forcing questions, refines the scope, and creates a ready PM ticket in your chosen tracker. The ticket creation process itself ensures quality — no separate readiness check needed.

## Usage

```
/human-ideate <rough idea or topic>
```

Accepts a freeform idea (e.g. `"add webhook support for tracker events"`).

## How it works

1. **Phase 1 — Context & challenge**: Explores the codebase for relevant code, existing tickets, and recent changes. Returns a context summary and tailored forcing questions.
2. Asks 5 forcing questions one at a time:
   - What is the actual pain? (not the feature request)
   - Who has this pain? (specific, not hypothetical)
   - What is the status quo? (how people cope today)
   - What is the narrowest wedge? (smallest version that delivers value)
   - What would make this 10-star? (dream big, then scope back)
3. Asks you to choose scope: **Expand** / **Hold** / **Reduce**
4. Asks which tracker to create the ticket in (Shortcut, Linear, Jira, etc.)
5. **Phase 2 — Generate ticket content**: Creates a structured ticket with problem statement, user story, acceptance criteria, and scope decisions
6. Creates the PM ticket on your chosen tracker
7. Adds a challenge record as a ticket comment (rejected alternatives, premise challenges, scope rationale)
8. Writes ideation record to `.human/ideation/<slug>.md`

## Output format

The created PM ticket contains:

```markdown
## Problem Statement
<grounded in the actual pain, not the feature request>

## User Story
As a <specific persona>, I want <narrowest wedge> so that <pain is addressed>.

## Acceptance Criteria
- [ ] <observable, testable criterion>
- [ ] ...

## Scope Decisions
- In scope: <what's included>
- Out of scope: <what's deferred>
- Rationale: <why this boundary>
```

The challenge record comment preserves:
- All 5 forcing question/answer pairs
- Rejected alternatives and why
- 10-star vision (deferred for future reference)

## Output location

- **Tracker ticket**: Created on your chosen tracker
- **Local record**: `.human/ideation/<slug>.md`

## Decision principles

The skill embeds these principles in every challenge:

- **Narrowest wedge first** — start with the smallest version that validates the core assumption
- **Actual pain over feature requests** — push past "I want X" to "because Y hurts"
- **Specific over hypothetical** — who exactly has this pain, today?
- **User sovereignty** — the agent challenges but never overrides your scope decision

## What comes next

Run [/human-plan](/docs/skills/human-plan/) to create an engineering implementation plan from the ticket. Or use [/human-sprint](/docs/skills/human-sprint/) to run the full pipeline automatically.
