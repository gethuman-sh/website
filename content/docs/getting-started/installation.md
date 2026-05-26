---
title: Installation
weight: 1
---

## Install script (recommended)

```bash
curl -sSfL gethuman.sh/install.sh | bash
```

Downloads the latest release binary for your platform and places it in your PATH.

## Homebrew

```bash
brew install stephanschmidt/tap/human
```

## mise

```bash
mise use -g github:StephanSchmidt/human
```

## Go

```bash
go install github.com/stephanschmidt/human@latest
```

Requires Go 1.21 or later.

## Verify

```bash
human --version
```

## Next steps

After installing, run `human init` to configure your project. See [Quick Start](/docs/getting-started/quickstart/).
