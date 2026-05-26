---
title: Troubleshooting
weight: 2
---

## "command not found" after install

The `human` binary is not in your PATH. The install script places it in `~/.local/bin/` by default.

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export PATH="$HOME/.local/bin:$PATH"
```

Reload your shell or run `source ~/.bashrc` (or `~/.zshrc`).

## Auth failures

**Wrong token or expired token:**

```bash
# Regenerate the daemon token
human daemon token
```

Copy the new token into your `HUMAN_DAEMON_TOKEN` environment variable.

**Wrong environment variable name:**

Verify the correct variable is set for your tracker. Each tracker uses a different variable:

| Tracker | Variable |
|---------|----------|
| Jira | `JIRA_API_TOKEN` |
| GitHub | `GITHUB_TOKEN` |
| GitLab | `GITLAB_TOKEN` |
| Linear | `LINEAR_API_KEY` |
| Azure DevOps | `AZURE_DEVOPS_PAT` |
| Shortcut | `SHORTCUT_API_TOKEN` |
| Notion | `NOTION_TOKEN` |
| Figma | `FIGMA_TOKEN` |
| Amplitude | `AMPLITUDE_API_KEY` + `AMPLITUDE_SECRET_KEY` |

## Daemon not reachable

Check if the daemon is running:

```bash
human daemon status
human daemon status --addr localhost:19285
```

Common causes:
- The daemon is not started — run `human daemon start` on the host
- Port not forwarded — add `19285` to `forwardPorts` in `devcontainer.json`
- Firewall blocking the port — ensure TCP `:19285` is open between container and host
- Wrong address — verify `HUMAN_DAEMON_ADDR` matches the daemon's listen address

## Chrome Bridge socket not found

Claude Code cannot find the MCP browser bridge socket.

1. Verify the chrome bridge is running: check for a `.sock` file in `/tmp/claude-mcp-browser-bridge-<username>/`
2. Verify environment variables are set: `HUMAN_CHROME_ADDR` and `HUMAN_DAEMON_TOKEN`
3. Check the bridge log: `~/.human/chrome-bridge.log`
4. Ensure port `19286` is forwarded in `devcontainer.json`

## Skill not found

If Claude Code does not recognize `/human-ready` or other skills:

```bash
human install --agent claude
```

This writes skill definitions to `.claude/skills/` and agent definitions to `.claude/agents/` in your project directory. Restart Claude Code after installing.
