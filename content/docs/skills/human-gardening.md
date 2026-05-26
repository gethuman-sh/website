---
title: /human-gardening
weight: 9
---

Analyzes codebase health using a multi-agent pipeline. Identifies structural debt, duplication, complexity hotspots, and hygiene issues, then produces a health scorecard with optional auto-fix.

## Usage

```
/human-gardening
```

No ticket or arguments needed. Run it in any codebase.

## How it works

The skill runs a 4-phase agent pipeline:

### Phase 1: Survey

A survey agent maps the codebase:
- Detects technologies via marker files (`go.mod`, `package.json`, `Cargo.toml`, etc.)
- Measures package sizes, exported symbols, and code:test ratios
- Maps coupling via fan-in/fan-out analysis on import statements
- Runs available static analysis tools (`go vet`, `gocyclo`, etc.)
- Analyzes git churn: hot files and co-changing file pairs
- Collects naming conventions and inconsistencies across packages
- Partitions files into 4 analysis domains

### Phase 2: Deep Analysis (4 parallel agents)

Four specialized agents run in parallel, each focused on a different health dimension:

| Agent | Focus |
|-------|-------|
| **Structure** | Package boundary violations, leaky abstractions, god packages, missing abstractions, architectural drift |
| **Duplication** | Structural clones, pattern duplication, extractable utilities, missed generics/interface opportunities |
| **Complexity** | Function length, nesting depth, cyclomatic complexity, mixed abstraction levels, file complexity, dead code |
| **Hygiene** | Naming inconsistencies, test health, dependency issues, convention violations, stale artifacts |

Each agent reads the survey report, deeply analyzes its assigned files, and also searches beyond assigned files for completeness.

### Phase 3: Triage

A triage agent validates all findings:
1. Re-reads actual code for every finding (reduces false positives)
2. Checks if the pattern is intentional (explained by comments or documented trade-offs)
3. Merges duplicates from different agents
4. Assesses **compound impact** — groups related medium findings into high-priority areas
5. Assigns maintainability impact (high/medium/low) based on spread and future cost
6. Computes health scorecard grades (A-F) per dimension
7. Creates atomic, behavior-preserving fix plans for each finding
8. Writes the final report and cleans up intermediate files

### Phase 4: Create Engineering Ticket

After the report, the skill asks which tracker and project to create a gardening ticket on. The full report (scorecard, findings, fix plans) becomes the ticket description. This ticket can then be executed with `/human-execute <KEY>`.

### Phase 5: Fix (optional)

After the ticket is created, you choose:
- **(A) Apply all high-impact fixes** — each fix follows a test-before/refactor/test-after/lint/commit cycle, reverted if tests fail
- **(B) Choose individual fixes** — pick from the numbered findings list
- **(C) Skip fixes** — run `/human-execute <KEY>` later to execute from the ticket

## What it finds that linters miss

- **Compound debt**: Three medium findings in the same package that combine into a critical hotspot
- **Structural clones**: Two packages that implement the same pattern differently — an interface extraction opportunity
- **Hidden coupling**: Files that always change together (from git history) but have no explicit dependency
- **Naming drift**: `Get` in one package, `Fetch` in another, `Load` in a third — for the same operation
- **Test imbalances**: Packages with zero test coverage next to packages with 3x test-to-code ratio

## Output format

```markdown
# Codebase Health Report

**Date**: YYYY-MM-DD HH:MM:SS
**Codebase**: <project name>
**Technologies**: ...
**Files analyzed**: N
**Findings**: N total (X high-impact, Y medium-impact, Z low-impact)

## Health Scorecard

| Dimension | Grade | Summary |
|-----------|-------|---------|
| Package Boundaries | B | Well-defined with one misplaced type |
| Duplication | C | Repeated HTTP client patterns across 4 providers |
| Complexity | B | Two functions over threshold, manageable |
| Test Health | A | Good coverage, meaningful assertions |
| Naming | C | Inconsistent getter prefixes across packages |
| Dependencies | A | Clean go.mod, no circular imports |

## High-Impact Findings
### 1. <Title>
- **File**: path/to/file.go:42
- **Category**: Structural debt
- **Impact**: high
- **Confidence**: certain / likely / possible
- **Evidence**: <code block>
- **Why it matters**: <compound impact, future cost>
- **Fix plan**: <atomic, behavior-preserving steps>
- **Effort**: small / medium / large

## Area Summaries
### <Package name>
- Findings: #1, #5, #8
- Combined impact: <how findings interact>
- Recommended approach: <fix together or separately?>

## Medium-Impact / Low-Impact Findings ...

## Recommended Gardening Order
1. **First**: <finding> — unblocks other fixes
2. **Second**: <finding> — high ROI
...

## False Positives Excluded
- <rejected findings with reason>
```

## Output location

`.human/gardening/gardening-<YYYYMMDD-HHMMSS>.md`

Intermediate files (`.human/gardening/.gardening-*.md`) are cleaned up by the triage agent.
