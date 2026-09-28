# CacheLayer Managed Keys for Claude Code

https://cachelayer.org/

Install the plugin, add your CacheLayer connect token, and restart Claude Code.

This repo is for managed keys only (`cl_…` as `CACHELAYER_KEY`).  
Personal API keys: https://cachelayer.org/integrations/claude-code

## 1. Add the CacheLayer marketplace

```text
/plugin marketplace add befugngr/cachelayer-claude-code-plugin
```

## 2. Install the CacheLayer plugin

```text
/plugin install cachelayer@cachelayer-claude-code-plugin
```

## 3. Reload plugins

```text
/reload-plugins
```

## 4. Add your CacheLayer token and restart Claude Code

Use a connect token from https://cachelayer.org/ (starts with `cl_`).

### macOS / Linux

```bash
export CACHELAYER_KEY="cl_<your-token>"

# Optional when Claude Code is launched outside the repository:
export CACHELAYER_WORKSPACE_ROOT="/absolute/path/to/repository"
```

To persist, add the same line to `~/.zshrc` or `~/.bashrc`.

If you launch Claude Code from Dock or Spotlight on macOS:

```bash
launchctl setenv CACHELAYER_KEY 'cl_<your-token>'
```

### Windows (PowerShell)

```powershell
[Environment]::SetEnvironmentVariable("CACHELAYER_KEY", "cl_<your-token>", "User")
```

Fully quit and reopen Claude Code.

## Compact + stable instructions

This plugin ships `CLAUDE.md` (always loaded) and `PreCompact` / `PostCompact` hooks that call CacheLayer before/after compaction.
