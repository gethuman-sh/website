---
title: "Open URLs on Host Browser from Claude Code Devcontainers"
sidebar_title: "Open URLs (human-browser)"
weight: 5
description: "Open URLs from inside devcontainers on the host browser. human-browser replaces xdg-open and $BROWSER inside containers — Claude Code auth, OAuth flows, documentation links, and preview URLs open on your host machine."
subtitle: "URLs opened inside a devcontainer appear on your host browser. OAuth redirects, preview links, and documentation just work."
docs_link: /docs/infrastructure/devcontainers/
---

## Fix xdg-open not working in devcontainers

When code inside a devcontainer tries to open a URL — whether it's an OAuth redirect, a documentation link, a test coverage report, or a local dev server preview — nothing happens. There's no browser inside the container. `xdg-open`, `open`, and `$BROWSER` all fail silently or error out.

This breaks:
- **OAuth flows** that need to open a browser for authentication
- **Claude Code** when it tries to open links or documentation
- **Dev server previews** that auto-open `localhost:3000`
- **Test reports** that open an HTML file in the browser
- **Any tool** that assumes a browser is available

## $BROWSER replacement for containers

`human-browser` is a drop-in replacement for `xdg-open` and the system browser inside devcontainers. Set it as `$BROWSER` in your container, and any tool that opens URLs will have those URLs open on your host machine instead.

```bash
# In the devcontainer
export BROWSER=human-browser

# Now any tool that opens URLs works
claude  # Claude Code can open links
npm start  # Dev server preview opens on host
pytest --cov --cov-report=html  # Coverage report opens on host
```

## How it works

`human-browser` sends the URL to the human daemon running on the host via the same TCP connection used for all container-to-host communication. The daemon opens the URL in the host's default browser.

```
[Devcontainer]                          [Host]
$BROWSER → human-browser               human daemon (:19285)
    |  TCP                                  |  opens URL in
    └───── :19285 ──────────────────────────┘  default browser
```

Token-based authentication ensures only authorized containers can open URLs on the host.

## Setup

The [treehouse](https://github.com/StephanSchmidt/treehouse) devcontainer Feature installs `human-browser` and sets `$BROWSER` automatically:

```json
{
  "features": {
    "ghcr.io/stephanschmidt/treehouse/human:1": {}
  },
  "remoteEnv": {
    "HUMAN_DAEMON_ADDR": "localhost:19285",
    "HUMAN_DAEMON_TOKEN": "a1b2c3...",
    "BROWSER": "human-browser"
  }
}
```

Or set it manually:

```bash
export BROWSER=human-browser
```

## Claude Code integration

Claude Code frequently needs to open URLs — for authentication, for showing documentation, for previewing changes. Inside a devcontainer without `human-browser`, these operations fail.

With `$BROWSER=human-browser`, Claude Code's browser interactions work transparently. Authentication flows complete. Links open. Your workflow isn't interrupted by "cannot open browser" errors.

## Works with any tool

`human-browser` follows the standard `$BROWSER` convention. Any Linux tool that respects `$BROWSER` or calls `xdg-open` works:

- **Node.js** `open` package
- **Python** `webbrowser` module
- **Rust** `open` crate
- **Go** `browser.OpenURL`
- **CLI tools** that open docs, dashboards, or reports

If the tool opens URLs, `human-browser` handles it.
