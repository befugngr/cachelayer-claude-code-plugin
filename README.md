# CacheLayer for Claude Code

Cache completed agent steps and reuse them in future tasks.

## Requirements

- Claude Code
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

The MCP server and PreToolUse hook use the same `CACHELAYER_KEY`.

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

## Security

- A valid `clct_...` token is required.
- Never save tokens or secrets from `.env` files in cached results.
- CacheLayer is a third-party service unaffiliated with Anthropic or Claude.
