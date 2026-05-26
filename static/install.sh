#!/bin/sh
set -eu

# human installer
# Usage: curl -sSfL gethuman.sh/install.sh | bash
# Override install dir: BINDIR=/path/to/bin curl ... | bash

REPO="StephanSchmidt/human"
BINDIR="${BINDIR:-/usr/local/bin}"

fail() { printf 'Error: %s\n' "$1" >&2; exit 1; }

# --- detect OS ---------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
  Linux*)  OS=linux  ;;
  Darwin*) OS=darwin ;;
  *)       fail "unsupported OS: $OS" ;;
esac

# --- detect arch --------------------------------------------------------------
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)       ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *)             fail "unsupported architecture: $ARCH" ;;
esac

# --- fetch latest version -----------------------------------------------------
printf 'Fetching latest release...\n'
VERSION="$(curl -sSfL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//')"

[ -z "$VERSION" ] && fail "could not determine latest version"
# strip leading 'v' for archive name
VERSION_NUM="${VERSION#v}"
printf 'Found version %s\n' "$VERSION"

# --- build download URLs ------------------------------------------------------
ARCHIVE="human_${VERSION_NUM}_${OS}_${ARCH}.tar.gz"
BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
ARCHIVE_URL="${BASE_URL}/${ARCHIVE}"
CHECKSUMS_URL="${BASE_URL}/checksums.txt"

# --- download into temp dir ---------------------------------------------------
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

printf 'Downloading %s...\n' "$ARCHIVE"
curl -sSfL -o "${TMPDIR}/${ARCHIVE}" "$ARCHIVE_URL"
curl -sSfL -o "${TMPDIR}/checksums.txt" "$CHECKSUMS_URL"

# --- verify checksum ----------------------------------------------------------
printf 'Verifying checksum...\n'
EXPECTED="$(grep "${ARCHIVE}" "${TMPDIR}/checksums.txt" | awk '{print $1}')"
[ -z "$EXPECTED" ] && fail "checksum not found for ${ARCHIVE}"

if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL="$(sha256sum "${TMPDIR}/${ARCHIVE}" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL="$(shasum -a 256 "${TMPDIR}/${ARCHIVE}" | awk '{print $1}')"
else
  fail "neither sha256sum nor shasum found"
fi

[ "$EXPECTED" != "$ACTUAL" ] && fail "checksum mismatch: expected ${EXPECTED}, got ${ACTUAL}"

# --- extract and install ------------------------------------------------------
printf 'Extracting...\n'
tar -xzf "${TMPDIR}/${ARCHIVE}" -C "$TMPDIR"

printf 'Installing to %s...\n' "$BINDIR"
install -d "$BINDIR"
install "${TMPDIR}/human" "${BINDIR}/human"

printf 'human %s installed to %s/human\n' "$VERSION" "$BINDIR"
