#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[whycomputer-runtime] %s\n' "$*"
}

fail() {
  printf '[whycomputer-runtime] ERROR: %s\n' "$*" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE="$PLUGIN_DIR/runtime/whycomputer-runtime-macos-arm64.zip"

[[ "$(uname -s)" == "Darwin" ]] || fail "This runtime is only available for macOS."
[[ "$(uname -m)" == "arm64" ]] || fail "This runtime package is for Apple Silicon Macs (arm64)."
[[ -f "$ARCHIVE" ]] || fail "Missing bundled runtime archive: $ARCHIVE"

APP_PATH="${WHYCOMPUTER_APP_PATH:-$HOME/Applications/whycomputer.app}"
CLI_DIR="${WHYCOMPUTER_CLI_DIR:-$HOME/.local/bin}"
CLI_PATH="$CLI_DIR/whycomputer"
STATE_DIR="$HOME/.local/state/whycomputer"
APP_PARENT="$(dirname "$APP_PATH")"

mkdir -p "$APP_PARENT" "$CLI_DIR" "$STATE_DIR" || fail "Could not create install directories. If Codex cannot write there, run this script from Terminal."
[[ -w "$APP_PARENT" ]] || fail "Cannot write to $APP_PARENT. Run this script from Terminal or set WHYCOMPUTER_APP_PATH to a writable app path."
[[ -w "$CLI_DIR" ]] || fail "Cannot write to $CLI_DIR. Run this script from Terminal or set WHYCOMPUTER_CLI_DIR to a writable bin directory."

TMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/whycomputer-runtime.XXXXXX")"
cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

log "Unpacking bundled runtime."
ditto -x -k "$ARCHIVE" "$TMPDIR"
[[ -d "$TMPDIR/whycomputer.app" ]] || fail "Archive did not contain whycomputer.app."
[[ -x "$TMPDIR/bin/whycomputer" ]] || fail "Archive did not contain executable bin/whycomputer."

if [[ -x "$CLI_PATH" ]]; then
  "$CLI_PATH" service-stop >/dev/null 2>&1 || true
fi

log "Installing app to $APP_PATH"
rm -rf "$APP_PATH"
ditto "$TMPDIR/whycomputer.app" "$APP_PATH"

log "Installing CLI to $CLI_PATH"
install -m 755 "$TMPDIR/bin/whycomputer" "$CLI_PATH"

xattr -dr com.apple.quarantine "$APP_PATH" "$CLI_PATH" >/dev/null 2>&1 || true
STATE_META="$STATE_DIR/release-metadata.json"
if cp "$APP_PATH/Contents/Resources/release-metadata.json" "$STATE_META" 2>/dev/null; then
  /usr/bin/plutil -replace install.app_path -string "$APP_PATH" "$STATE_META" 2>/dev/null || true
  /usr/bin/plutil -replace install.cli_path -string "$CLI_PATH" "$STATE_META" 2>/dev/null || true
  /usr/bin/plutil -replace install.service_path -string "$APP_PATH/Contents/MacOS/whycomputer-service" "$STATE_META" 2>/dev/null || true
  /usr/bin/plutil -convert json -o "$STATE_META" "$STATE_META" 2>/dev/null || true
fi

codesign --verify --deep --strict "$APP_PATH" >/dev/null
codesign --verify --strict "$CLI_PATH" >/dev/null

if ! spctl --assess --type execute "$APP_PATH" >/dev/null 2>&1; then
  log "Gatekeeper assessment did not return accepted. The app is signed and notarized, but macOS may need network access or a manual first open."
fi

log "Installed runtime:"
"$CLI_PATH" version

if [[ ":$PATH:" != *":$CLI_DIR:"* ]]; then
  log "Add $CLI_DIR to PATH if 'whycomputer' is not found in new shells."
fi

if [[ "${WHYCOMPUTER_SKIP_SERVICE_START:-0}" == "1" ]]; then
  log "Skipped service start because WHYCOMPUTER_SKIP_SERVICE_START=1."
else
  "$CLI_PATH" service-start >/dev/null 2>&1 || log "Service did not start yet. Grant permissions if macOS prompts, then run: $CLI_PATH service-start"
  "$CLI_PATH" permissions-status --no-screen-recording-probe || true
fi

log "Done."
