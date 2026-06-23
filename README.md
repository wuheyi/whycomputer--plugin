# whycomputer Codex plugin

This repository is a Codex plugin marketplace for `whycomputer`.

It intentionally contains only:

- `.agents/plugins/marketplace.json`
- `plugins/whycomputer/.codex-plugin/plugin.json`
- `plugins/whycomputer/skills/whycomputer/`
- `plugins/whycomputer/scripts/install-runtime.sh`
- `plugins/whycomputer/runtime/whycomputer-runtime-macos-arm64.zip`

It does not contain the Swift package, app implementation, tests, build
tests, or `whycomputer` source code. The runtime zip contains only signed
macOS binaries for the app and CLI.

## Install from GitHub

```bash
codex plugin marketplace add https://github.com/wuheyi/whycomputer--plugin.git --ref main --sparse .agents --sparse plugins/whycomputer
codex plugin add whycomputer@whycomputer-plugin
```

Install the local macOS runtime that the plugin uses:

```bash
~/.codex/.tmp/marketplaces/whycomputer-plugin/plugins/whycomputer/scripts/install-runtime.sh
```

Start a new Codex thread after installing so the `whycomputer` skill is loaded.

## Add from the Codex app

Codex also supports adding this marketplace from the app UI.

Open **Plugins**, click **+**, then fill:

```text
Source: https://github.com/wuheyi/whycomputer--plugin.git
Git ref: main
Sparse path:
.agents
plugins/whycomputer
```

Keep both sparse paths. The `plugins/whycomputer` path includes the bundled
runtime installer and zip, so no Homebrew package or source checkout is needed.

After the marketplace appears, open `whycomputer` and select **Add to Codex**.

## Share link from the Codex app

For a click-to-install link, use Codex workspace sharing:

1. Add and install `whycomputer` in your Codex app.
2. Open the `whycomputer` plugin details page.
3. Select **Share**.
4. Copy the share link or invite workspace members.

Workspace share links are managed by Codex and are intended for users in the
same ChatGPT workspace. For users outside that workspace, use the GitHub
marketplace install flow above.

## Local runtime

The plugin teaches Codex how to use the `whycomputer` command and includes a
local runtime installer for Apple Silicon macOS 14+.

The installer writes:

```text
~/Applications/whycomputer.app
~/.local/bin/whycomputer
```

Then verify:

```bash
whycomputer version
whycomputer service-status
whycomputer permissions-status
```

If Codex cannot write to `~/Applications`, run the installer from Terminal, or
choose another app location:

```bash
WHYCOMPUTER_APP_PATH="$HOME/.local/share/whycomputer/whycomputer.app" \
  ~/.codex/.tmp/marketplaces/whycomputer-plugin/plugins/whycomputer/scripts/install-runtime.sh
```

## Why not share a codex:// local link?

Do not share a personal `codex://plugins/...marketplacePath=/Users/...` link
with another machine. That URL points at an absolute path on the machine that
opens it, so another user will see an error like:

```text
marketplace file `/Users/example/.agents/plugins/marketplace.json` does not exist
```

Use the GitHub marketplace commands above instead.
