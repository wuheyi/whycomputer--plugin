#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_URL="https://github.com/wuheyi/whycomputer--plugin.git"
MARKETPLACE_NAME="whycomputer-plugin"
PLUGIN_NAME="whycomputer"

codex plugin marketplace add "$MARKETPLACE_URL" --ref main
codex plugin add "$PLUGIN_NAME@$MARKETPLACE_NAME"

cat <<EOF
Installed Codex plugin:
  Plugin: $PLUGIN_NAME@$MARKETPLACE_NAME
  Marketplace: $MARKETPLACE_URL

Start a new Codex thread so the whycomputer skill is loaded.
EOF
