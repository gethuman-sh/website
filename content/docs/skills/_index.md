---
title: Skills
weight: 4
---

Skills encode a development workflow as a chain where each step produces artifacts consumed by the next. Each skill fetches the ticket from your configured issue tracker, performs its analysis, and writes a structured markdown report to the `.human/` directory.

## Install

```bash
human install --agent claude
```

This writes skill and agent definitions to your project's `.claude/skills/` and `.claude/agents/` directories. This is also part of `human init`.

## Available skills

| Skill | Purpose |
|-------|---------|
| [/human-ideate](/docs/skills/human-ideate/) | Challenge an idea with forcing questions and create a ready PM ticket |
| [/human-sprint](/docs/skills/human-sprint/) | Run the full pipeline in one command: ideate → plan → execute → review |
| [/human-ready](/docs/skills/human-ready/) | Evaluate a ticket against a Definition of Ready checklist |
| [/human-brainstorm](/docs/skills/human-brainstorm/) | Brainstorm implementation approaches before planning |
| [/human-plan](/docs/skills/human-plan/) | Create an implementation plan from a ticket |
| [/human-execute](/docs/skills/human-execute/) | Execute a plan step by step |
| [/human-review](/docs/skills/human-review/) | Review changes against acceptance criteria |
| [/human-bug-plan](/docs/skills/human-bug-plan/) | Analyze a bug and create a fix plan |
| [/human-findbugs](/docs/skills/human-findbugs/) | Scan the codebase for bugs using a multi-agent pipeline |
| [/human-security](/docs/skills/human-security/) | Deep security audit with attack chain analysis |
| [/human-gardening](/docs/skills/human-gardening/) | Codebase health analysis with health scorecard and optional auto-fix |

## Lifecycle flow

The skills follow a development lifecycle:

```
/human-ideate → /human-plan → /human-execute → /human-review
```

Or run the full pipeline in one command with `/human-sprint`.

For existing tickets that weren't created through `/human-ideate`, start with `/human-ready` to validate them, then `/human-plan`. For bugs, use `/human-bug-plan`. For proactive bug scanning, use `/human-findbugs`. For security audits, use `/human-security`. For codebase health checks, use `/human-gardening`.

You can use the full chain or individual skills independently. For example, `/human-review` works on any branch with changes, whether or not a plan exists.

## Output directory

All skill output is written to the `.human/` directory in your project root:

```
.human/
  ideation/<slug>.md  -- Ideation records with challenge history
  ready/<key>.md      -- Definition of Ready assessments
  brainstorms/<id>.md -- Brainstorm documents
  plans/<key>.md      -- Implementation plans
  reviews/<key>.md    -- Code reviews
  bugs/<key>.md       -- Bug analyses
  bugs/findbugs-*.md  -- Bug scan reports
  security/*.md       -- Security audit reports
  gardening/*.md      -- Codebase health reports
```

File names use the lowercased ticket key (e.g. `KAN-1` becomes `kan-1.md`).
