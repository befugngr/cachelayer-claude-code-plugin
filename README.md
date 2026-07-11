# CacheLayer for Claude Code

Claude Code plugin: MCP step cache plus a PreToolUse **command** hook that checks CacheLayer before tools run.

Site: https://cachelayer.org/

## Install

In Claude Code:

```text
/plugin marketplace add befugngr/cachelayer-claude-code-plugin
/plugin install cachelayer@cachelayer-claude-code-plugin
/reload-plugins
```

(`cachelayer` alone may work after the marketplace is added; the `name@marketplace` form matches Claude Code’s documented install style.)

Or test locally without a marketplace:

```bash
claude --plugin-dir ./cachelayer-claude-code-plugin
```

Confirm MCP and the PreToolUse hook are loaded.

### Auth (required)

Set `CACHELAYER_CONNECT_TOKEN` to your `clct_...` connect token. The bundled `.mcp.json` sends it as `Authorization: Bearer …`, and `scripts/pre_tool_use.sh` sends the same header to the hook. Unauthenticated MCP/hook requests return **401**.

MCP URL: `https://api.cachelayer.org/mcp/sse`

## Layout

```text
.claude-plugin/plugin.json
.claude-plugin/marketplace.json
.mcp.json
hooks/hooks.json
scripts/pre_tool_use.sh
skills/cachelayer-tools/SKILL.md
```

## Tools

- `lookup_step` / `save_step` / `check_conflict` / `run_status`
- PreToolUse hook: `type: "command"` → `scripts/pre_tool_use.sh` → `POST https://api.cachelayer.org/hooks/pre-tool-use` (fail-open, 2s timeout). Not a native `type: "http"` hook.

## Limits

- Hook fail-open: if CacheLayer is down, slow, or returns non-2xx (including 401 without a token), the tool proceeds
- Keep descriptions short so lookups match saves

## Compliance

1. No impersonation. CacheLayer only; not Anthropic or Claude.
2. No malicious code.
3. A CacheLayer account/subscription is required.

## Contact

https://cachelayer.org/

## Legal

Apache License 2.0. See `LICENSE`.
