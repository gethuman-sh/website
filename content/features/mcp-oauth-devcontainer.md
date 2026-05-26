---
title: "MCP OAuth Authentication in Devcontainers for Claude Code"
sidebar_title: "MCP/OAuth in Containers"
weight: 3
description: "Fix MCP OAuth not working in devcontainers. The human daemon proxies browser-based OAuth flows from the container to the host — no port forwarding hacks. Includes Claude Code subscription linking inside containers."
subtitle: "OAuth flows from inside devcontainers just work. The daemon proxies MCP authentication to the host browser — no workarounds needed."
docs_link: /docs/infrastructure/devcontainers/
---

## How to fix MCP OAuth not working in devcontainers

MCP servers that require OAuth authentication need a browser redirect. The server starts a local HTTP listener, opens a browser, the user authenticates, and the OAuth provider redirects back to `localhost` with an authorization code.

Inside a devcontainer, this breaks at every step. There's no browser. `localhost` inside the container is not the same `localhost` the OAuth provider redirects to. Port forwarding helps sometimes, but it's fragile and different for every MCP server.

The result: teams that use devcontainers for isolation and reproducibility are locked out of MCP servers that need OAuth. They either skip devcontainers or skip OAuth-dependent tools.

## How human solves MCP OAuth in containers

The human daemon runs on the host where a browser exists and OAuth redirects work. When an MCP server inside the container needs to authenticate:

1. The MCP server initiates the OAuth flow as usual
2. The human daemon intercepts the callback URL and opens the browser on the host
3. The user authenticates in their host browser
4. The OAuth redirect completes on the host
5. The daemon relays the authorization code back to the MCP server in the container

From the MCP server's perspective, the OAuth flow just worked. No code changes, no special configuration, no port forwarding.

## Setup

```bash
# On the host
human daemon start

# In the devcontainer (set via devcontainer.json remoteEnv)
export HUMAN_DAEMON_ADDR=localhost:19285
export HUMAN_DAEMON_TOKEN=a1b2c3...
```

That's it. MCP servers that use browser-based OAuth can now authenticate from inside the container.

## Claude Code subscription linking inside containers

Claude Code's own authentication uses a similar browser-based flow. When Claude Code needs to link to your Anthropic account inside a devcontainer, the daemon proxies that flow to the host browser too.

Your team can run Claude Code in devcontainers without anyone needing to manually copy session tokens or authentication cookies. The subscription link just works — open the container, start Claude Code, authenticate once through the host browser.

## Works with any MCP server

This isn't specific to human's own connectors. Any MCP server running inside the devcontainer that uses browser-based OAuth benefits from the daemon proxy. GitHub MCP, Slack MCP, Google MCP — if it opens a browser for auth, the daemon handles the redirect.

## devcontainer.json example

```json
{
  "features": {
    "ghcr.io/stephanschmidt/treehouse/human:1": {}
  },
  "forwardPorts": [19285, 19286],
  "remoteEnv": {
    "HUMAN_DAEMON_ADDR": "localhost:19285",
    "HUMAN_DAEMON_TOKEN": "a1b2c3...",
    "HUMAN_CHROME_ADDR": "localhost:19286"
  }
}
```

A ready-to-use example is available in the [treehouse test-devcontainer](https://github.com/StephanSchmidt/treehouse/tree/main/test-devcontainer).

## Why it matters

Devcontainers are the right way to run AI agents for teams. They provide reproducibility, isolation, and security. But OAuth — the authentication standard almost every SaaS product uses — doesn't work inside containers without help.

human's daemon makes OAuth transparent. Your team gets devcontainer isolation without giving up any MCP server that needs browser-based authentication.
