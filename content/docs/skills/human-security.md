---
title: /human-security
weight: 8
---

Deep security audit of the codebase using a 4-phase multi-agent pipeline. Auto-detects technologies, maps the attack surface, scans for vulnerabilities, and chains findings into exploitable attack paths.

## Usage

```
/human-security
```

No ticket or arguments needed. Run it in any codebase.

## How it works

The skill runs a 4-phase agent pipeline:

### Phase 1: Attack Surface Mapping

A surface mapping agent performs attacker-style reconnaissance:
- Detects technologies and frameworks (including security-relevant version details)
- Maps all entry points: HTTP endpoints, CLI args, file inputs, message handlers, WebSockets
- Identifies trust boundaries: which routes require auth, which are public
- Traces sensitive data flows: passwords, tokens, PII, financial data
- Catalogs cryptographic usage and dependency manifests
- Partitions files into 5 scanning domains

### Phase 2: Specialized Scanning (5 parallel agents)

Five specialized agents run in parallel, each focused on a different security domain:

| Agent | Focus |
|-------|-------|
| **Injection** | SQL injection, command injection, XSS, path traversal, template injection, log injection, header injection |
| **Auth** | Broken authentication, IDOR, privilege escalation, session management, CSRF, OAuth vulnerabilities, API key security |
| **Secrets** | Hardcoded secrets, leaked credentials in git history, weak cryptography, insecure randomness, sensitive data exposure |
| **Dependencies** | Known CVEs via audit tools, outdated packages, supply chain risks (typosquatting, postinstall scripts), dependency confusion |
| **Infrastructure** | Docker misconfigurations, CI/CD pipeline security, CORS, TLS, HTTP security headers, file permissions, rate limiting, IaC |

Each agent reads the surface map, deeply analyzes its assigned files, and also searches beyond assigned files for defense-in-depth.

### Phase 3: Attack Chain Analysis

This is the phase that makes the scanner better than running individual tools. A dedicated agent:
1. Reads all scanning reports and the surface map
2. Connects individual findings into multi-step attack chains (e.g., "information disclosure on endpoint A reveals user IDs, which enables IDOR on endpoint B, which exposes admin tokens")
3. Scores each chain by entry point accessibility, skill required, and impact
4. Verifies each chain against actual code to confirm exploitability

### Phase 4: Triage

A triage agent validates all findings:
1. Re-reads actual code for every finding
2. Checks if existing security controls mitigate the finding
3. Checks for test coverage and explanatory comments
4. Validates attack chain steps and connections
5. Assigns severity (critical/high/medium/low) based on exploitability and impact
6. Maps findings to OWASP Top 10 categories
7. Writes the final report with prioritized recommendations

## What it finds that static analysis tools miss

- **Attack chains**: Individual medium findings that chain into a critical exploit path
- **Missing security**: Endpoints without auth middleware, routes without CSRF protection — the absence of security is a finding
- **IDOR**: "Can User A access User B's data by changing the ID?" — requires understanding authorization intent
- **Context-aware secrets**: Distinguishes a real AWS key from a test fixture, a hardcoded password from an environment variable fallback
- **Reachability**: Knows whether a dependency CVE's vulnerable function is actually called by the project

## Output format

```markdown
# Security Scan Report

**Date**: YYYY-MM-DD HH:MM:SS
**Codebase**: <project name>
**Technologies**: ...
**Entry points scanned**: N
**Vulnerabilities found**: N (X critical, Y high, Z medium, W low)
**Attack chains identified**: N

## Executive Summary
<2-3 sentences readable by non-technical stakeholders>

## Attack Chains
### Chain 1: <Name> [CRITICAL]
**Steps**: entry point → finding A → finding B → impact
**Immediate action**: <what to fix to break the chain>

## Critical / High / Medium / Low
### 1. <Title>
- **File**: path/to/file.go:42
- **Category**: <OWASP category>
- **Confidence**: certain / likely / possible
- **Description**: ...
- **Evidence**: <code block>
- **Exploitation**: <how an attacker exploits this>
- **Impact**: ...
- **Suggested fix**: <code block>

## OWASP Top 10 Coverage
| # | Category | Status |
|---|----------|--------|
| A01 | Broken Access Control | Checked — N findings |
...

## Recommendations Priority
1. **Immediate**: <critical findings and chain-breaking fixes>
2. **This sprint**: <high findings>
3. **Backlog**: <medium and low findings>
```

## Output location

`.human/security/security-<YYYYMMDD-HHMMSS>.md`

Intermediate files (`.human/security/.security-*.md`) are cleaned up by the triage agent.
