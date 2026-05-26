---
title: "Protect .env Files from AI Agents in Devcontainers"
sidebar_title: ".env Secret Protection"
weight: 5
description: "Prevent Claude Code and other AI agents from reading secrets in .env files. A host-side FUSE filesystem mirrors your workspace but serves .env files as empty. Zero container config, no SYS_ADMIN needed."
subtitle: "AI agents see your .env files exist but can never read the secrets inside. Host-side FUSE, zero container config."
docs_link: /docs/infrastructure/devcontainers/#env-file-protection
---

## How to prevent AI coding agents from reading .env secrets

When AI agents run inside devcontainers, the project directory is bind-mounted into the container. This means `.env` files — containing API keys, database credentials, and other secrets — are fully readable by the agent. A compromised or careless agent can read and exfiltrate these credentials.

## FUSE-based .env filtering for Claude Code devcontainers

The human daemon creates a FUSE mount that mirrors your entire workspace. The container mounts this filtered view instead of the real directory. Regular files pass through at native speed. `.env` files appear in directory listings but return empty content when read. Writes to `.env` files are blocked.

```
/home/you/project/              (real directory)
├── .env                        API_KEY=sk-1234567890
├── src/app.js                  console.log("hello")
└── config/.env.local           DB_PASSWORD=hunter2

/home/you/project-sec/          (FUSE mount — what the agent sees)
├── .env                        (empty)
├── src/app.js                  console.log("hello")
└── config/.env.local           (empty)
```

The agent knows which `.env` files exist and can reference their keys in code, but never sees the actual secret values.

## How it works

FUSE (Filesystem in Userspace) runs on the **host**, not inside the container. No special container permissions needed — no `SYS_ADMIN`, no AppArmor changes, no `/dev/fuse` in the container.

```
Agent reads /workspace/src/app.js
  → bind mount → FUSE passthrough → real file (native speed)

Agent reads /workspace/.env
  → bind mount → FUSE intercept → empty content

Agent writes /workspace/.env
  → bind mount → FUSE → read-only filesystem error
```

Non-`.env` files use FUSE passthrough for near-native I/O performance. On Linux kernel 6.9+ (Docker Desktop macOS, Ubuntu 24.10+), the kernel bypasses the FUSE daemon entirely for regular file I/O.

## Setup

Start the daemon from your project directory:

```bash
human daemon start
```

The daemon automatically creates the FUSE mount at `<project>-sec/`. The output shows the mount path:

```
FUSE .env filter: /home/you/project-sec
```

If FUSE is not available on the host, the daemon logs a warning and continues without `.env` protection.

## Protected file patterns

The filter matches these filenames in any directory:

- `.env`
- `.env.local`
- `.env.production`
- `.env.development`
- `.env.test`
- `.env.*` (any `.env.` prefix)

## Defense in depth

The FUSE `.env` filter complements human's other security features:

- **Credential isolation** — API tokens and credentials stay on the host, never enter the container
- **[HTTPS proxy](/features/firewall-proxy-devcontainer/)** — allowlist or blocklist domains the agent can reach
- **FUSE .env filter** — secrets in `.env` files are invisible to the agent

Together, these give teams three layers of protection for AI-assisted development: credentials never enter the container, secrets in files are hidden, and network access is controlled.
