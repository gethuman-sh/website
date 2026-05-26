---
title: /human-brainstorm
weight: 1.5
---

Explores the codebase, asks clarifying questions, and generates 2-3 implementation approaches with trade-offs before you commit to a plan.

## Usage

```
/human-brainstorm <ticket-key or topic>
```

Accepts either a ticket key (e.g. `KAN-1`, `ENG-123`) or a freeform topic (e.g. `"add caching layer for API responses"`).

## How it works

1. **Phase 1 — Context gathering**: Fetches the ticket (if a key was given), explores the codebase for relevant code, patterns, and existing `.human/` artifacts
2. Presents a context summary and asks 3-5 clarifying questions one at a time
3. **Phase 2 — Generate approaches**: Incorporates your answers and generates 2-3 distinct implementation approaches
4. Presents the approaches with trade-offs, pros/cons, complexity estimates, and a recommendation
5. Asks you which approach to proceed with
6. Writes the complete brainstorm to `.human/brainstorms/<identifier>.md`

## Output format

```markdown
## Problem Statement
<what needs to be solved>

## Context
<summary of relevant codebase areas, patterns, and constraints>

## Clarifications
| Question | Answer |
|----------|--------|
| <q1>     | <a1>   |

## Approaches

### Approach 1: <name>
<description>

**Affected files:** <list>

| Pros | Cons |
|------|------|
| <pro> | <con> |

**Complexity:** small / medium / large
**Risks:** <risks and mitigations>

### Approach 2: <name>
...

## Recommendation
<which approach and why>

## Chosen approach
<the approach you selected>
```

## Output location

`.human/brainstorms/<identifier>.md`

The identifier is the lowercased ticket key (e.g. `kan-1.md`) or a slugified topic (e.g. `add-caching-layer-for-api-responses.md`).

## What comes next

Run [/human-plan](/docs/skills/human-plan/) to turn the chosen approach into a concrete implementation plan.
