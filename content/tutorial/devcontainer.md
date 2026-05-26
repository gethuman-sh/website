---
title: "Devcontainers to go --yolo"
sidebar_title: Devcontainers
weight: 1
---

This tutorial walks through setting up a devcontainer where Claude Code has full access to your issue tracker, Chrome, Notion, Figma, and Amplitude — while credentials never enter the container.

## What you'll end up with

```
Devcontainer                        Host
                                    human daemon
human jira issues list  ------->    CLI proxy      (:19285)
claude --chrome         ------->    Chrome proxy   (:19286)
HTTPS requests          ------->    HTTPS proxy    (:19287)
human-browser           ------->    URL opener
secret files            ------->    FUSE filter    (redacted / empty)
```

Credentials stay on the host. The agent never sees API tokens or secrets.

## Part 1: Quick setup with `human init`

### 1. Install human on the host

```bash
curl -sSfL gethuman.sh/install.sh | bash
human --version
```

### 2. Run the setup wizard

```bash
cd /path/to/your/project
human init
```

The wizard walks you through three steps:

1. **Services** — pick your trackers and tools (Jira, GitHub, Linear, Notion, Figma, …) and configure them. This creates `.humanconfig.yaml`.
2. **Devcontainer** — generates `.devcontainer/devcontainer.json` with the daemon, Chrome proxy, language stacks, and optionally the HTTPS firewall.
3. **Agent install** — sets up the Claude Code integration.

### 3. Set your API tokens

The wizard prints which environment variables you need. Export them on the host:

```bash
export JIRA_WORK_KEY=your-api-token
```

### 4. Start the daemon and the container

```bash
human daemon start
devcontainer up --workspace-folder .
```

If you don't have the devcontainer CLI yet:

```bash
npm install -g @devcontainers/cli
```

That's it. Open a shell inside and verify:

```bash
devcontainer exec --workspace-folder . bash
human jira issues list --project=<your-project>
```

---

## Part 2: Manual setup step by step

If you prefer to set things up yourself — or need to customize beyond what the wizard offers — follow these steps. They cover the same ground as `human init` plus the optional features.

### 1. Install human on the host

```bash
curl -sSfL gethuman.sh/install.sh | bash
human --version
```

### 2. Configure your tracker

Create a `.humanconfig.yaml` in your project directory. Here's an example for Jira:

```yaml
trackers:
  - name: work
    type: jira
    url: https://your-org.atlassian.net
    user: you@example.com
```

Set the API token (or use a password vault to inject it):

```bash
export JIRA_WORK_KEY=your-api-token
```

Quick test on the host:

```bash
human jira issues list --project=<your-project>
```

### 3. Start the daemon

```bash
human daemon start
```

Output:

```
Token: a1b2c3d4e5f6...
Token file: ~/.human/daemon-token
Listening on: :19285
Chrome proxy on: :19286
HTTPS proxy on: :19287
FUSE .env filter: /home/you/project-sec
```

Save the token — you need it for the devcontainer config.

The daemon forwards CLI commands from the container to the host, where credentials live. It also runs the Chrome proxy, HTTPS proxy, and FUSE `.env` filter.

### 4. Set up the devcontainer

If you don't have the devcontainer CLI yet, install it:

```bash
npm install -g @devcontainers/cli
```

[treehouse](https://github.com/StephanSchmidt/treehouse) is a devcontainer Feature that installs human inside the container. It also provides a ready-made devcontainer setup you can use as a starting point — clone the repo and copy the `.devcontainer` folder into your project. Create a `.devcontainer/devcontainer.json` in your project:

```json
{
  "features": {
    "ghcr.io/stephanschmidt/treehouse/human:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
  },
  "forwardPorts": [19285, 19286],
  "remoteEnv": {
    "HUMAN_DAEMON_ADDR": "localhost:19285",
    "HUMAN_DAEMON_TOKEN": "a1b2c3d4e5f6...",
    "HUMAN_CHROME_ADDR": "localhost:19286"
  }
}
```

Start the devcontainer from your project directory:

```bash
cd /path/to/your/project
devcontainer up --workspace-folder .
```

Open a shell inside:

```bash
devcontainer exec --workspace-folder . bash
```

Verify the connection to the host daemon:

```bash
human daemon status
```

Test a command — it runs inside the container but the daemon executes it on the host with your credentials:

```bash
human jira issues list --project=<your-project>
```

### 5. Enable Chrome Bridge

With the config from step 4, `claude --chrome` already works. The Chrome proxy tunnels Chrome DevTools Protocol from the container to Chrome on the host.

Start the bridge inside the container:

```bash
human chrome-bridge
```

Now start Claude Code with Chrome access:

```bash
claude --chrome
```

Claude can use Chrome for visual testing, OAuth flows, and web scraping — all from inside the devcontainer.

### 6. Link your Claude subscription

Normally, linking Claude Code to your Anthropic subscription inside a devcontainer fails — the OAuth flow needs a browser, and there's no browser in the container.

With the daemon running, this just works. When Claude Code starts the authentication flow, the daemon proxies it to your host browser. Authenticate there, and the redirect completes back inside the container.

```bash
claude
# Follow the subscription link — it opens on your host browser
```

This also works for any MCP server that uses browser-based OAuth (GitHub, Slack, Google, etc.).

### 7. Add the HTTPS firewall

Control which domains the agent can reach. Configure allowed domains in `.humanconfig.yaml` on the host:

```yaml
proxy:
  mode: allowlist
  domains:
    - "*.github.com"
    - "api.anthropic.com"
    - "registry.npmjs.org"
    - "pypi.org"
```

Update `devcontainer.json` to enable the proxy:

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
    "HUMAN_DAEMON_TOKEN": "a1b2c3d4e5f6...",
    "HUMAN_CHROME_ADDR": "localhost:19286",
    "HUMAN_PROXY_ADDR": "${localEnv:HUMAN_PROXY_ADDR}"
  },
  "postStartCommand": "sudo human-proxy-setup && human install --agent claude"
}
```

`proxy: true` installs iptables and the redirect script at build time. `human-proxy-setup` activates the iptables rules at container start. Any HTTPS request to a domain not on the allowlist is dropped.

The proxy reads the SNI from the TLS handshake — no certificates, no traffic decryption.

### 8. Protect secrets

The daemon automatically creates a FUSE mount that mirrors your project directory. Secret files (`.env`, `.npmrc`, `.pypirc`, `credentials.json`, `*.pem`, `*.key`, and more) are protected — the agent sees the structure but not the secrets.

By default, the daemon **redacts** sensitive values while preserving file structure:

```
/home/you/project/           (real)
├── .env                     API_KEY=sk-1234567890
│                            PORT=3000
├── server.pem               -----BEGIN CERTIFICATE-----
├── src/app.js               console.log("hello")

/home/you/project-sec/       (what the agent sees)
├── .env                     API_KEY=***
│                            PORT=3000
├── server.pem               (empty — binary files can't be redacted)
├── src/app.js               console.log("hello")
```

The agent sees which keys exist and their safe values (like `PORT=3000`), but secrets are replaced with `***`. Binary key files (`.pem`, `.key`, `.p12`, `.pfx`) always return empty content since they can't be meaningfully redacted. Writes to all protected files are blocked.

For maximum paranoia, use `--safe` to return **completely empty** files instead of redacted ones:

```bash
human daemon start --safe
```

FUSE runs entirely on the host — no container changes needed. The daemon creates a filtered mirror of your project at `project-sec/`. Start the daemon before opening the devcontainer so the FUSE mount is ready:

```bash
cd /path/to/your/project
human daemon start
devcontainer up --workspace-folder .
```

### 9. Open URLs on the host

Set `BROWSER` in your `devcontainer.json`:

```json
{
  "remoteEnv": {
    "BROWSER": "human-browser"
  }
}
```

Now any tool inside the container that opens a URL — OAuth redirects, dev server previews, test reports — opens it in the host browser.

```bash
# Works inside the container
human browser https://example.com
```

### Full devcontainer.json

Everything together:

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
    "HUMAN_DAEMON_TOKEN": "a1b2c3d4e5f6...",
    "HUMAN_CHROME_ADDR": "localhost:19286",
    "HUMAN_PROXY_ADDR": "${localEnv:HUMAN_PROXY_ADDR}",
    "BROWSER": "human-browser"
  },
  "postStartCommand": "sudo human-proxy-setup && human install --agent claude"
}
```

### Environment variables reference

| Variable | Purpose |
|----------|---------|
| `HUMAN_DAEMON_ADDR` | Daemon address (`localhost:19285`) |
| `HUMAN_DAEMON_TOKEN` | Auth token from `human daemon token` |
| `HUMAN_CHROME_ADDR` | Chrome proxy (`localhost:19286`) |
| `HUMAN_PROXY_ADDR` | HTTPS proxy (`192.168.1.5:19287`) |
| `BROWSER` | Set to `human-browser` to open URLs on host |

### 10. Reduce confirmation prompts

Now that we put Claude into a tightly controlled, secure shell we can loosen the restrictions on Claude itself. Claude Code asks for permission on every tool call — inside a devcontainer with the firewall and `.env` protection in place, you can safely relax this.

The philosophy: **allow reading everything, allow safe CLI tools, allow web research, restrict writing and executing to specific patterns.**

### Start simple: allow human commands

If you only want to skip prompts for the `human` CLI:

```bash
claude --allowTools "Bash(human *)"
```

### Recommended safe set

This set auto-approves read-only operations and common dev commands while still prompting for file writes and destructive actions:

```bash
claude \
  --allowTools \
    "Read" \
    "Glob" \
    "Grep" \
    "WebSearch" \
    "WebFetch" \
    "Bash(git status)" \
    "Bash(git log *)" \
    "Bash(git diff *)" \
    "Bash(ls *)" \
    "Bash(human *)" \
    "Bash(npm run *)" \
    "Bash(npx tsc *)" \
    "Bash(node *)"
```

What this allows — and why it's safe:

| Pattern | Why safe |
|---------|----------|
| `Read`, `Glob`, `Grep` | Read-only file access — no side effects |
| `WebSearch`, `WebFetch` | Web research — no side effects (HTTPS firewall already restricts domains) |
| `Bash(git status)`, `Bash(git log *)`, `Bash(git diff *)` | Read-only git info |
| `Bash(ls *)` | Directory listing — read-only |
| `Bash(human *)` | All human CLI commands (the whole point of this setup) |
| `Bash(npm run *)` | Project scripts — typically build, test, lint |
| `Bash(npx tsc *)` | TypeScript type checking — read-only analysis |
| `Bash(node *)` | Run node scripts |

What still requires confirmation:

- **`Edit` / `Write`** — file modifications always prompt
- **`Bash(git commit *)`, `Bash(git push *)`** — git writes prompt
- **`Bash(rm *)`, `Bash(mv *)`** — destructive operations prompt
- **`Bash(curl *)`, `Bash(wget *)`** — network operations prompt (HTTPS firewall is a second layer, but belt-and-suspenders)
- **`Agent`** — spawning subagents prompts

This eliminates ~80% of confirmation prompts. Most Claude interactions are reading files, searching code, running tests, and browsing docs — all auto-approved. Every file edit and destructive command still requires your approval.

Customize for your stack — add `"Bash(cargo test *)"` for Rust, `"Bash(go test *)"` for Go, `"Bash(pytest *)"` for Python, or remove patterns you don't need.

### Nuclear option: skip all permissions

Or go fully autonomous — Claude runs without any confirmation prompts:

```bash
claude --dangerously-skip-permissions
```

This is safe**r** inside a devcontainer because you already have three layers of protection: credentials stay on the host, secrets are redacted by the FUSE filter, and the HTTPS firewall controls network access.

<p style="color: #ff4444; font-weight: 700; font-size: 1.1rem;">Warning: --dangerously-skip-permissions means Claude can delete files, overwrite code, run arbitrary shell commands, and make destructive changes without asking. It is called "dangerously" for a reason. Only use it when you fully trust the task, have committed your work, and can review the diff after. If the agent has AWS access or similar, it might delete databases or backups. Never use it outside a devcontainer on your host machine.</p>
