---
title: "Built-in Development Skills for Claude Code"
sidebar_title: "Development Skills"
weight: 6
description: "Claude Code skills for the full development lifecycle — Definition of Ready, brainstorming, planning, execution, code review, bug analysis, security audits, and codebase health gardening. Built-in slash commands that work with any issue tracker."
subtitle: "From ticket to shipped code. Built-in Claude Code skills cover readiness checks, planning, execution, and review."
docs_link: /docs/skills/
---

## How to create a Definition of Ready for Claude Code

Claude Code is great at writing code. But code is the easy part. The hard part is everything around it: Is the ticket ready? What's the implementation approach? Does the code match the acceptance criteria? Are there edge cases? Security issues?

human's built-in Claude Code skills cover the full development lifecycle as slash commands. Each skill fetches the ticket from your configured issue tracker, performs its analysis, and writes a structured report to the `.human/` directory. `/human-ready` in particular enforces a Definition of Ready checklist before any code is written — stopping the "build the wrong thing" failure mode at the source.

## The lifecycle

```
/human-ideate → /human-plan → /human-execute → /human-review
```

Or run the full pipeline in one command:

```
/human-sprint  (ideate → plan → execute → review, auto-decides mechanical questions)
```

Use the full chain or any skill independently. `/human-review` works on any branch with changes, whether or not a plan exists.

## Available skills

### /human-ideate — Challenge and create PM ticket

Takes a rough idea, challenges the premise with 5 forcing questions (actual pain, who has it, status quo, narrowest wedge, 10-star vision), then creates a ready PM ticket in your chosen tracker. The creation process itself ensures quality — no separate readiness check needed.

```
/human-ideate "add webhook support for tracker events"
```

Output: PM ticket on your chosen tracker + ideation record in `.human/ideation/`.

### /human-sprint — Full pipeline in one command

Chains ideate → plan → execute → review into a single flow. Auto-decides mechanical questions using encoded decision principles. Surfaces only genuine taste decisions (scope, architecture tradeoffs) for your input.

```
/human-sprint "add rate limiting to the API"
```

Choose how far to go: tickets only, plan + execute, or full pipeline.

### /human-ready — Definition of Ready

Fetches a ticket and evaluates it against a Definition of Ready checklist. Checks description, acceptance criteria, scope, dependencies, context, and edge cases. Asks you to fill in any gaps before implementation starts.

```
/human-ready KAN-42
```

Stop building the wrong thing. Catch missing requirements before the first line of code.

### /human-brainstorm — Explore approaches

Brainstorms implementation approaches before committing to a plan. Explores trade-offs, identifies risks, and surfaces alternative solutions you might not have considered.

```
/human-brainstorm KAN-42
```

Output saved to `.human/brainstorms/` for reference during planning.

### /human-plan — Implementation plan

Fetches a ticket, explores the codebase, and produces a structured implementation plan. Identifies files to change, dependencies, test strategy, and step-by-step tasks.

```
/human-plan KAN-42
```

Plans are saved to `.human/plans/` and consumed by `/human-execute`.

### /human-execute — Execute the plan

Loads a plan from `.human/plans/` and executes it step by step. Writes code, creates tests, and runs a review checkpoint at the end to verify the result matches the plan.

```
/human-execute KAN-42
```

### /human-review — Code review

Reviews the current branch's changes against the ticket's acceptance criteria. Flags gaps, scope creep, missing edge cases, and code quality issues. Like a senior developer reviewing before merge.

```
/human-review KAN-42
```

Reviews are saved to `.human/reviews/`.

### /human-bug-plan — Bug analysis

Analyzes a bug ticket for root cause, traces affected code paths, and produces a fix plan. Understands the difference between a feature ticket and a bug — focuses on diagnosis, not feature planning.

```
/human-bug-plan BUG-17
```

### /human-findbugs — Proactive bug scanning

Scans the codebase for bugs using a multi-agent pipeline. No ticket needed. Finds logic errors, error handling gaps, race conditions, and security vulnerabilities that existing tests miss.

```
/human-findbugs
```

### /human-security — Security audit

Deep security audit with attack chain analysis. Maps the attack surface, scans for injection, auth, secrets, dependency, and infrastructure vulnerabilities, then chains findings into exploitable paths.

```
/human-security
```

### /human-gardening — Codebase health analysis

Analyzes structural debt, duplication, complexity hotspots, and hygiene issues using a multi-agent pipeline. Produces a health scorecard (A-F grades per dimension) with compound impact assessment, creates an engineering ticket with the fix plan, and optionally applies fixes. Run `/human-execute` on the ticket later, or fix immediately.

```
/human-gardening
```

## One install

```bash
human install --agent claude
```

This writes skill definitions to your project's `.claude/skills/` directory. Also included in `human init`.

## Works with any issue tracker

Skills automatically fetch tickets from whichever tracker you've configured — Jira, GitHub, GitLab, Linear, Azure DevOps, or Shortcut. Switch trackers, keep the same skills.

## Structured output

All skill output is written to the `.human/` directory in your project root:

```
.human/
  ideation/<slug>.md    — Ideation records with challenge history
  ready/<key>.md        — Definition of Ready assessments
  brainstorms/<id>.md   — Brainstorm documents
  plans/<key>.md        — Implementation plans
  reviews/<key>.md      — Code reviews
  bugs/<key>.md         — Bug analyses
  bugs/findbugs-*.md    — Bug scan reports
  security/*.md         — Security audit reports
  gardening/*.md        — Codebase health reports
```

Reports are markdown, easy to review, and tracked in git. Your team's development process becomes auditable and reproducible.

## Claude Code code review and bug analysis skills

`/human-review` runs a code review of the current branch's changes against the ticket's acceptance criteria, flagging gaps, scope creep, and missing edge cases — essentially a senior developer's pre-merge review pass, run automatically. `/human-bug-plan` takes a bug ticket and produces a root-cause analysis with a fix plan, understanding the difference between "add a feature" and "diagnose a bug". `/human-findbugs` scans the codebase proactively without a ticket, finding logic errors, error handling gaps, race conditions, and security holes that existing tests miss.

## Why skills, not prompts

You could paste a long prompt every time. Skills are better because:

- **Consistent** — every developer runs the same workflow, same checklist, same quality bar
- **Connected** — skills fetch live ticket data from your tracker, not copy-pasted descriptions
- **Chained** — output from one skill feeds the next (/human-plan output is consumed by /human-execute)
- **Auditable** — structured reports in `.human/` create a paper trail for compliance
- **Updatable** — update human, and every skill improves across your entire team
