# CacheLayer for Claude Code

https://cachelayer.org/

CacheLayer controls the agent through silent tool hooks and MCP — not by proxying the LLM. Hooks look up/save steps and put only the needed cached result back on a hit.

Personal / BYOK: https://cachelayer.org/integrations/claude-code

## How CacheLayer controls the agent

The plugin does **not** attach your editor to the LLM proxy. Silent hooks sit on tool use:

1. **Before** allowlisted read/search tools → lookup a prior safe step result
2. On **hit** → skip the native tool and put only that cached result back into the agent
3. **After** the tool → save the result for the next step
4. Optional MCP tools (`lookup_step`, `save_step`, `check_conflict`, `run_status`) for explicit control

Set `CACHELAYER_KEY` (`cl_…` or legacy `clct_…`). For per-flow Agent OS metrics in the console:

```bash
export CACHELAYER_FLOW_ID="<flow_id_from_console>"
```

Hooks and MCP stay on `https://api.cachelayer.org`.


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
