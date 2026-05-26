---
title: "HTTPS Proxy and Firewall for Claude Code in Devcontainers"
sidebar_title: "Firewall & HTTPS Proxy"
weight: 4
description: "Restrict AI agent network access from devcontainers with an HTTPS proxy. Allowlist or blocklist domains, inspect outbound traffic by SNI — no certificates, no decryption. Transparent iptables redirect."
subtitle: "Control what your Claude Code agent can reach. Allowlist or blocklist domains — no certificates, no traffic decryption."
docs_link: /docs/infrastructure/devcontainers/#https-proxy
---

## How to restrict AI coding agent network access

AI agents running inside devcontainers have the same network access as any process in that container. An agent that can reach the internet can exfiltrate code, call unauthorized APIs, download untrusted packages, or communicate with arbitrary endpoints.

For teams that care about security — and every team running AI agents on proprietary code should — unrestricted outbound network access from a coding agent is an unacceptable risk.

## Allowlist domains for AI agents

The human daemon includes a transparent HTTPS proxy that filters outbound traffic from devcontainers by domain. It reads the SNI (Server Name Indication) from the TLS ClientHello — no certificates needed, no traffic decryption. Your traffic stays encrypted end-to-end.

Configure allowed or blocked domains in `.humanconfig.yaml` on the host:

```yaml
proxy:
  mode: allowlist    # or "blocklist"
  domains:
    - "*.github.com"
    - "api.openai.com"
    - "api.anthropic.com"
    - "registry.npmjs.org"
    - "pypi.org"
```

| Mode | Behavior |
|------|----------|
| `allowlist` | Only listed domains pass, everything else is blocked |
| `blocklist` | Only listed domains are blocked, everything else passes |
| No `proxy:` section | Block all outbound traffic (safe default) |

Wildcard `*.example.com` matches subdomains but not `example.com` itself.

## How it works

The proxy runs on port 19287 as part of the human daemon. Inside the devcontainer, iptables rules redirect all outbound HTTPS traffic through the proxy. The proxy inspects only the SNI field — the unencrypted domain name in the TLS handshake — and either forwards or blocks the connection.

```
[Devcontainer]                          [Host]
HTTPS request ──→ iptables redirect     human daemon (:19287)
                  ──→ proxy             ──→ SNI check
                                        ──→ allow/block
```

No MITM. No certificate installation. No trust store modification. The proxy sees which domain is being connected to, not what data is being sent.

## Setup

Enable the proxy in your `devcontainer.json` using the [treehouse](https://github.com/StephanSchmidt/treehouse) devcontainer Feature:

```json
{
  "features": {
    "ghcr.io/stephanschmidt/treehouse/human:1": {
      "proxy": true
    }
  },
  "capAdd": ["NET_ADMIN"],
  "forwardPorts": [19285, 19286],
  "remoteEnv": {
    "HUMAN_DAEMON_ADDR": "localhost:19285",
    "HUMAN_DAEMON_TOKEN": "a1b2c3...",
    "HUMAN_CHROME_ADDR": "localhost:19286",
    "HUMAN_PROXY_ADDR": "${localEnv:HUMAN_PROXY_ADDR}"
  },
  "postStartCommand": "sudo human-proxy-setup"
}
```

The `proxy: true` option installs `iptables` and the `human-proxy-setup` script at image build time. At container start, the script reads `HUMAN_PROXY_ADDR` and sets up the iptables redirect. If the variable is unset, the script skips gracefully.

`NET_ADMIN` capability is required for iptables rules inside the container.

## Allowlist: the default for production teams

For teams shipping proprietary code, start with an allowlist. Explicitly permit the domains your build and test process needs — package registries, APIs, CI services — and block everything else.

```yaml
proxy:
  mode: allowlist
  domains:
    # Package registries
    - "registry.npmjs.org"
    - "*.npmjs.org"
    - "pypi.org"
    - "*.pypi.org"
    # AI APIs
    - "api.anthropic.com"
    - "api.openai.com"
    # Source control
    - "*.github.com"
    - "*.gitlab.com"
    # Your internal services
    - "*.internal.company.com"
```

If the agent tries to reach a domain not on the list, the connection is dropped. No data leaves the container to unauthorized endpoints.

## Blocklist: quick protection for known-bad domains

If a full allowlist is too restrictive for your workflow, use a blocklist to block specific known-bad or sensitive domains while allowing everything else:

```yaml
proxy:
  mode: blocklist
  domains:
    - "*.competitor.com"
    - "pastebin.com"
    - "*.paste.ee"
```

## SNI-based outbound filtering without TLS interception

Most proxy solutions require installing a custom CA certificate so the proxy can decrypt and inspect HTTPS traffic. This breaks certificate pinning, complicates container setup, and means your proxy sees plaintext traffic.

SNI-based filtering avoids all of this. The domain name is sent unencrypted during the TLS handshake — the proxy reads it and makes a pass/block decision before the encrypted session starts. Your data stays encrypted. No CA certificates. No trust store changes. No compliance headaches.

## Security for AI development teams

Unrestricted AI agents are a security risk. The HTTPS proxy gives your security team a single configuration file that controls what every AI agent in every devcontainer can reach. Combined with human's credential isolation (secrets never enter the container), you get defense in depth for AI-assisted development.
