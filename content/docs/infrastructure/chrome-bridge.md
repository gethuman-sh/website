---
title: Chrome Bridge
weight: 2
---

The Chrome Bridge enables `claude --chrome` to work inside devcontainers. Claude Code's Chrome integration uses Chrome's native messaging protocol to communicate with the browser extension, which does not work from inside a container because Chrome runs on the host.

## Architecture

```
[Devcontainer]                              [Host]
Claude Code --chrome                        Chrome + Extension
    |  (Unix socket)                            ^  (native messaging)
human chrome-bridge                         human daemon
    |  TCP (:19286)                             ^  (SocketRelay)
    └──────────── TCP tunnel ───────────────────┘
```

## How it works

1. `human daemon start` on the host starts the daemon (`:19285`), chrome proxy (`:19286`), and a SocketRelay that listens on a Unix socket in `/tmp/claude-mcp-browser-bridge-<username>/`
2. `human chrome-bridge` in the container creates a Unix socket at the same path that Claude Code uses to discover the MCP browser bridge
3. When Claude Code connects to the socket, the bridge tunnels traffic over TCP to the daemon's chrome proxy
4. The daemon pairs the connection with a Chrome native messaging connection via the SocketRelay

## Host setup

Start the daemon on your host machine:

```bash
human daemon start
```

This starts both the main daemon and the chrome proxy. The output shows the environment variables to export in the container.

## Container setup

```bash
export HUMAN_CHROME_ADDR=<host-ip>:19286
export HUMAN_DAEMON_TOKEN=<token>
human chrome-bridge
```

The bridge runs as a background process by default. Use `--foreground` to run in the foreground.

## Environment variables

| Variable | Description |
|----------|-------------|
| `HUMAN_CHROME_ADDR` | Host address and port for the chrome proxy (e.g. `192.168.1.5:19286`) |
| `HUMAN_DAEMON_TOKEN` | Authentication token (from `human daemon token` or `human daemon start` output) |

## Flags

| Flag | Description |
|------|-------------|
| `--foreground` | Run in foreground instead of daemonizing |

## Files

| Path | Description |
|------|-------------|
| `~/.human/chrome-bridge.log` | Bridge log file |
| `/tmp/claude-mcp-browser-bridge-<username>/<pid>.sock` | Unix socket created by the bridge |
