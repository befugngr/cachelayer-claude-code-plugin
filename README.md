# CacheLayer for Claude Code

Cache completed agent steps and reuse them in future tasks.

## Prerequisites

- Claude Code
- Git for Windows (required for marketplace installation)
  - Install: `winget install --id Git.Git -e`
  - Or download from https://git-scm.com/
- A CacheLayer connect token (`clct_...`) from https://cachelayer.org/

## Install

```text
/plugin marketplace add befugngr/cachelayer-claude-code-plugin
/plugin install cachelayer@cachelayer-claude-code-plugin
/reload-plugins
```

For local testing:

```bash
claude --plugin-dir ./cachelayer-claude-code-plugin
```

## Authenticate

Set the token before starting Claude Code:

```bash
export CACHELAYER_KEY='clct_<your-token>'
claude
```

The bundled `.mcp.json` uses:

```json
{
  "mcpServers": {
    "cachelayer": {
      "type": "http",
      "url": "https://api.cachelayer.org/mcp",
      "headers": {
        "Authorization": "Bearer ${CACHELAYER_KEY}"
      }
    }
  }
}
```

The MCP server and PreToolUse/PostToolUse hooks use the same `CACHELAYER_KEY`. Hooks are fail-open (~2s); prefer them over calling MCP before every tool.

## Verify

- The `cachelayer` MCP server is connected.
- `lookup_step`, `save_step`, `check_conflict`, and `run_status` are available.
- The `cachelayer-tools` skill is loaded.

## Repository layout

```text
.claude-plugin/plugin.json
.claude-plugin/marketplace.json
hooks/hooks.json
scripts/pre_tool_use.sh
skills/cachelayer-tools/SKILL.md
.mcp.json
LICENSE
README.md
```

## Troubleshooting

If marketplace installation fails with `git not found`:

1. Install Git from https://git-scm.com/.
2. Restart your terminal and Claude Code.
3. Try the full repository URL:

   ```text
   /plugin marketplace add https://github.com/befugngr/cachelayer-claude-code-plugin.git
   ```

4. Or clone the repository and add it locally:

   ```bash
   git clone https://github.com/befugngr/cachelayer-claude-code-plugin.git
   ```

   ```text
   /plugin marketplace add ./cachelayer-claude-code-plugin
   ```

## Security

- A valid `clct_...` token is required.
- Never save tokens or secrets from `.env` files in cached results.
- CacheLayer is a third-party service unaffiliated with Anthropic or Claude.
