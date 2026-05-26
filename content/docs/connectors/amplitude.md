---
title: Amplitude
weight: 9
---

Connect to Amplitude — product analytics, events, funnels, retention, and cohorts.

## Configuration

```yaml
amplitude:
  token_env: AMPLITUDE_API_KEY
  secret_env: AMPLITUDE_SECRET_KEY
```

## Commands

```bash
# List events
human amplitude events list

# List cohorts
human amplitude cohorts list
```

AI agents can query analytics data to inform implementation decisions.
