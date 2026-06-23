# whycomputer Codex plugin

This repository is a Codex plugin marketplace for `whycomputer`.

It intentionally contains only:

- `.agents/plugins/marketplace.json`
- `plugins/whycomputer/.codex-plugin/plugin.json`
- `plugins/whycomputer/skills/whycomputer/`

It does not contain the Swift package, app implementation, tests, build
artifacts, or `whycomputer` source code.

## Install from GitHub

```bash
codex plugin marketplace add https://github.com/wuheyi/whycomputer--plugin.git --ref main
codex plugin add whycomputer@whycomputer-plugin
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

The sparse path is optional for this repository because it only contains plugin
distribution files, but the two-line value above keeps the install focused on
the marketplace and plugin bundle.

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

## Local prerequisite

The plugin teaches Codex how to use the `whycomputer` command. It does not
install the macOS app or CLI.

Before using the plugin, each machine needs a working local installation:

```bash
whycomputer version
whycomputer service-status
whycomputer permissions-status
```

The expected app path is:

```text
~/Applications/whycomputer.app
```

## Why not share a codex:// local link?

Do not share a personal `codex://plugins/...marketplacePath=/Users/...` link
with another machine. That URL points at an absolute path on the machine that
opens it, so another user will see an error like:

```text
marketplace file `/Users/example/.agents/plugins/marketplace.json` does not exist
```

Use the GitHub marketplace commands above instead.
