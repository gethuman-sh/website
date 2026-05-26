---
title: /human-findbugs
weight: 7
---

Scans the codebase for bugs using a multi-agent pipeline. Auto-detects technologies and finds semantic bugs that static analysis tools miss.

## Usage

```
/human-findbugs
```

No ticket or arguments needed. Run it in any codebase.

## How it works

The skill runs a 3-phase agent pipeline:

### Phase 1: Reconnaissance

A recon agent maps the codebase:
- Detects technologies via marker files (`go.mod`, `package.json`, `Cargo.toml`, etc.)
- Runs available lightweight static analysis (`go vet`, `npm audit`, etc.)
- Identifies high-risk files via heuristics: recent git changes, large files, TODO/FIXME/HACK comments, concurrency primitives, error-heavy code, external I/O
- Partitions files into 4 analysis domains

### Phase 2: Deep Analysis (4 parallel agents)

Four specialized agents run in parallel, each focused on a different concern:

| Agent | Focus |
|-------|-------|
| **Logic** | Off-by-one errors, wrong operators, dead branches, shadowed variables, copy-paste bugs, naming contradictions |
| **Errors** | Swallowed errors, resource leaks, missing nil checks, inconsistent error propagation, deferred calls with mutable state |
| **Concurrency** | Race conditions, deadlocks, goroutine/thread leaks, missing synchronization, TOCTOU bugs, context cancellation issues |
| **API & Security** | Injection vulnerabilities, interface contract violations, serialization mismatches, missing input validation, config bugs |

Each agent reads the recon report, deeply analyzes its assigned files, and also Greps beyond assigned files for defense-in-depth.

### Phase 3: Triage

A triage agent validates all findings:
1. Re-reads actual code for every finding (reduces false positives)
2. Checks if existing tests already guard against the bug
3. Checks if the "bug" is intentional (explained by comments)
4. Merges duplicates from different agents
5. Assigns final severity based on impact and reachability
6. Writes the final report and cleans up intermediate files

## What it finds that linters miss

- **Intent mismatches**: function named `isValid` that returns true for invalid input
- **Cross-file data flow**: error propagated in one file but swallowed in another
- **Test/code disagreements**: test asserts behavior X but code does Y
- **Logic errors**: code compiles and runs but produces wrong results

## Output format

```markdown
# Bug Scan Report

**Date**: YYYY-MM-DD HH:MM:SS
**Codebase**: <project name>
**Technologies**: ...
**Files scanned**: N
**Bugs found**: N (X critical, Y high, Z medium, W low)

## Critical
### 1. <Title>
- **File**: path/to/file.go:42
- **Category**: Race condition
- **Confidence**: Certain
- **Description**: ...
- **Evidence**: <code block>
- **Impact**: ...
- **Suggested fix**: <code block>

## High / Medium / Low ...

## Summary by Category
| Category | Critical | High | Medium | Low |
|----------|----------|------|--------|-----|

## False Positive Candidates Excluded
- <rejected findings with reason>
```

## Output location

`.human/bugs/findbugs-<YYYYMMDD-HHMMSS>.md`

Intermediate files (`.human/bugs/.findbugs-*.md`) are cleaned up by the triage agent.
