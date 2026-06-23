#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_URL="https://github.com/wuheyi/whycomputer--plugin.git"
MARKETPLACE_NAME="whycomputer-plugin"
PLUGIN_NAME="whycomputer"

codex plugin marketplace add "$MARKETPLACE_URL" --ref main --sparse .agents --sparse "plugins/$PLUGIN_NAME"
codex plugin add "$PLUGIN_NAME@$MARKETPLACE_NAME"

RUNTIME_INSTALLER="$HOME/.codex/.tmp/marketplaces/$MARKETPLACE_NAME/plugins/$PLUGIN_NAME/scripts/install-runtime.sh"
if [[ -x "$RUNTIME_INSTALLER" ]]; then
  "$RUNTIME_INSTALLER"
else
  echo "Runtime installer not found at $RUNTIME_INSTALLER" >&2
  echo "The plugin is installed, but the local app and CLI still need to be installed." >&2
fi

cat <<EOF
Installed Codex plugin:
  Plugin: $PLUGIN_NAME@$MARKETPLACE_NAME
  Marketplace: $MARKETPLACE_URL

Start a new Codex thread so the whycomputer skill is loaded.
EOF
