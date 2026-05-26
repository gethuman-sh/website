---
title: Devcontainers
weight: 1
---

AI agents inside devcontainers need access to issue trackers, Notion, Figma, and Amplitude, but credentials should stay on the host. human solves this with a daemon that forwards CLI commands from the container to the host.

## Architecture

```
[Devcontainer]                          [Host]
human jira issues list                  human daemon (:19285)
    |  TCP                                  |  (executes command with
    └───── :19285 ──────────────────────────┘    host credentials)
```

The daemon also runs a chrome proxy on `:19286` for [Chrome Bridge](/docs/infrastructure/chrome-bridge/) support, an HTTPS proxy on `:19287` for [outbound traffic filtering](#https-proxy), and a [FUSE .env filter](#env-file-protection) that hides secrets from the agent.

Install `human` inside devcontainers using the [treehouse](https://github.com/StephanSchmidt/treehouse) devcontainer Feature.

## Host setup

```bash
human daemon start
```

Output:

```
Token: a1b2c3...
Token file: ~/.human/daemon-token
Listening on: :19285
Chrome proxy on: :19286
HTTPS proxy on: :19287
FUSE .env filter: /home/you/project-sec

Run in the container:
  export HUMAN_DAEMON_ADDR=192.168.1.5:19285 HUMAN_DAEMON_TOKEN=a1b2c3... HUMAN_CHROME_ADDR=192.168.1.5:19286 HUMAN_PROXY_ADDR=192.168.1.5:19287
```

## Container setup

In your `devcontainer.json`, add the [treehouse](https://github.com/StephanSchmidt/treehouse) devcontainer Feature:

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

## Usage

Inside the container, all commands work transparently:

```bash
human jira issues list --project=KAN
human notion search "quarterly report"
human figma file get ABC123
```

The daemon handles authentication and API calls on the host.

## Security

- Token-based authentication: the daemon generates a token at `~/.human/daemon-token`
- The token is created on first run via `human daemon start` or `human daemon token`
- All requests from the container must include the token
- Credentials and API tokens remain on the host and are never sent to the container

## HTTPS proxy

The daemon includes a transparent HTTPS proxy on port 19287 that filters outbound traffic from devcontainers by domain. It reads the SNI from TLS ClientHello — no certificates needed, no traffic decryption.

Configure allowed domains in `.humanconfig.yaml` on the host:

```yaml
proxy:
  mode: allowlist    # or "blocklist"
  domains:
    - "*.github.com"
    - "api.openai.com"
    - "registry.npmjs.org"
```

| Mode | Behavior |
|------|----------|
| `allowlist` | Only listed domains pass, everything else blocked |
| `blocklist` | Only listed domains blocked, everything else passes |
| No `proxy:` section | Block all (safe default) |

Wildcard `*.example.com` matches subdomains but not `example.com` itself.

Enable in `devcontainer.json` using the [treehouse](https://github.com/StephanSchmidt/treehouse) Feature:

```json
{
  "features": {
    "ghcr.io/stephanschmidt/treehouse/human:1": {
      "proxy": true
    },
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
  },
  "capAdd": ["NET_ADMIN"],
  "forwardPorts": [19285, 19286],
  "remoteEnv": {
    "HUMAN_DAEMON_ADDR": "localhost:19285",
    "HUMAN_DAEMON_TOKEN": "a1b2c3...",
    "HUMAN_CHROME_ADDR": "localhost:19286",
    "HUMAN_PROXY_ADDR": "${localEnv:HUMAN_PROXY_ADDR}"
  },
  "postStartCommand": "sudo human-proxy-setup && human install --agent claude"
}
```

The `proxy: true` option installs `iptables` and the `human-proxy-setup` script at image build time. At container start, the script reads `HUMAN_PROXY_ADDR` and sets up the iptables redirect. If the variable is unset, the script skips gracefully.

## .env file protection

The daemon creates a FUSE mount at `<project>-sec/` that mirrors your workspace. The container mounts this filtered view instead of the real directory. Regular files pass through at native speed. `.env` files appear in directory listings but return empty content when read. Writes to `.env` files are blocked with a read-only filesystem error.

Protected patterns: `.env`, `.env.local`, `.env.production`, `.env.*` — any file starting with `.env` in any directory.

No container changes needed. No `SYS_ADMIN`, no `/dev/fuse`, no FUSE packages. The FUSE daemon runs entirely on the host. If FUSE is not available, the daemon logs a warning and continues without `.env` protection.

See the [.env Secret Protection feature page](/features/env-filter-devcontainer/) for details.

## Environment variables

| Variable | Description |
|----------|-------------|
| `HUMAN_DAEMON_ADDR` | Daemon address (e.g. `localhost:19285`) |
| `HUMAN_DAEMON_TOKEN` | Authentication token |
| `HUMAN_CHROME_ADDR` | Chrome proxy address (e.g. `localhost:19286`) |
| `HUMAN_PROXY_ADDR` | HTTPS proxy address (e.g. `192.168.1.5:19287`). Printed by `human daemon start`. |

## Daemon commands

```bash
human daemon start             # Start the daemon
human daemon start --addr :8080  # Start on a custom port
human daemon token             # Print the current token
human daemon status            # Check if a daemon is reachable
human daemon status --addr host:port  # Check a specific address
```
