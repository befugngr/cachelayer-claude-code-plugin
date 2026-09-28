# CacheLayer for Claude Code

https://cachelayer.org/

CacheLayer Agent OS sits in front of the LLM: it clears the agent’s memory and only gives it what the current step needs. This plugin connects your editor (managed keys, hooks, and MCP).

Personal / BYOK: https://cachelayer.org/integrations/claude-code

## Agent OS (LLM traffic)

Point the model at CacheLayer Agent OS so it clears memory and only gives the agent what the current step needs:

```bash
export OPENAI_BASE_URL="https://api.cachelayer.org/cl-gate/v1"
export OPENAI_API_KEY="$CACHELAYER_KEY"
# Optional Anthropic-shaped clients:
# export ANTHROPIC_BASE_URL="https://api.cachelayer.org/cl-gate"
# export ANTHROPIC_API_KEY="$CACHELAYER_KEY"
```

Hooks and MCP stay on `https://api.cachelayer.org` (unchanged).

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

Use a connect token from https://cachelayer.org/ (`cl_…` or legacy `clct_…`).

### macOS / Linux

```bash
export CACHELAYER_KEY="<your-token>"

# Optional when Claude Code is launched outside the repository:
export CACHELAYER_WORKSPACE_ROOT="/absolute/path/to/repository"
```

To persist, add the same line to `~/.zshrc` or `~/.bashrc`.

If you launch Claude Code from Dock or Spotlight on macOS:

```bash
launchctl setenv CACHELAYER_KEY '<your-token>'
```

### Windows (PowerShell)

```powershell
[Environment]::SetEnvironmentVariable("CACHELAYER_KEY", "<your-token>", "User")
```

Fully quit and reopen Claude Code.
