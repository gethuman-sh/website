#!/usr/bin/env bash
# theme-svg.sh — Post-process an Affinity-exported SVG to use CSS custom
# properties so it renders with the website's dark palette.
#
# Usage: ./scripts/theme-svg.sh <input-src.svg> <output.svg>

set -euo pipefail

src="${1:?usage: theme-svg.sh <input> <output>}"
out="${2:?usage: theme-svg.sh <input> <output>}"

# ── CSS custom-property definitions ──────────────────────────────────
style_block='<style>:root{--svg-bg:#0d0d0d;--svg-container-outer:rgba(245,196,104,0.08);--svg-container-inner:rgba(245,196,104,0.15);--svg-box-primary:#f5c468;--svg-box-secondary:rgba(245,196,104,0.35);--svg-box-pink:rgba(232,72,152,0.25);--svg-box-gray:#2a2a3e;--svg-box-red:#e05050;--svg-arrow-fill:#4ee8c4;--svg-arrow-stroke:#4ee8c4;--svg-text-dark:#e0e0e0;--svg-text-light:#ffffff;--svg-border:#2a2a3e;--svg-border-thin:#2a2a3e;}</style>'

# Background rect injected after the first <g>
bg_rect='<rect width="100%" height="100%" style="fill:var(--svg-bg);"/>'

sed \
  -e "s|<svg \([^>]*\)>|<svg \1>${style_block}|" \
  -e "s|<g>|<g>${bg_rect}|1" \
  -e 's|fill:#0d0d0d;fill-rule:nonzero;|fill:var(--svg-text-dark);fill-rule:nonzero;|g' \
  -e 's|fill:#fff;fill-rule:nonzero;|fill:var(--svg-text-light);fill-rule:nonzero;|g' \
  -e 's|style="fill-rule:nonzero;"|style="fill:var(--svg-text-dark);fill-rule:nonzero;"|g' \
  -e 's|fill:#ffee97;|fill:var(--svg-container-outer);|g' \
  -e 's|fill:#ffe047;|fill:var(--svg-container-inner);|g' \
  -e 's|fill:#f5cd00;|fill:var(--svg-box-primary);|g' \
  -e 's|fill:#ffc000;|fill:var(--svg-box-secondary);|g' \
  -e 's|fill:#e59edd;|fill:var(--svg-box-pink);|g' \
  -e 's|fill:#d9d9d9;|fill:var(--svg-box-gray);|g' \
  -e 's|fill:#f00;|fill:var(--svg-box-red);|g' \
  -e 's|fill:#92d050;|fill:var(--svg-arrow-fill);|g' \
  -e 's|stroke:#000;stroke-width:1.5px;|stroke:var(--svg-border);stroke-width:1.5px;|g' \
  -e 's|stroke:#000;stroke-width:0.99px;|stroke:var(--svg-border);stroke-width:0.99px;|g' \
  -e 's|stroke:#0d0d0d;stroke-width:0.99px;|stroke:var(--svg-border-thin);stroke-width:0.99px;|g' \
  -e 's|stroke:#00b050;stroke-width:1px;|stroke:var(--svg-arrow-stroke);stroke-width:1px;|g' \
  "$src" > "$out"

echo "Themed: $src → $out"
