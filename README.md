# CacheLayer for Claude Code

Claude Code plugin: MCP step cache plus a PreToolUse hook that checks CacheLayer before tools run.

Site: https://cachelayer.org/

## Install

```text
/plugin marketplace add befugngr/cachelayer-claude-code-plugin
/plugin install cachelayer
```

Or test locally:

```bash
claude --plugin-dir ./cachelayer-claude-code-plugin
```

Then start a new session. Confirm MCP and the PreToolUse hook are loaded.

MCP URL (in `.mcp.json`): `https://api.cachelayer.org/mcp/sse`

When auth ships, set `CACHELAYER_CONNECT_TOKEN` for the hook. Add Authorization on the MCP entry without changing the URL.

## Layout

```text
.claude-plugin/plugin.json
.mcp.json
hooks/hooks.json
scripts/pre_tool_use.sh
skills/cachelayer-tools/SKILL.md
```

## Tools

- `lookup_step` / `save_step` / `check_conflict` / `run_status`
- PreToolUse command hook → `POST https://api.cachelayer.org/hooks/pre-tool-use` (fail-open, 2s)

## Limits

- Hook fail-open: if CacheLayer is down or slow, the tool proceeds
- Keep descriptions short so lookups match saves

## Compliance

1. No impersonation. CacheLayer only; not Anthropic or Claude.
2. No malicious code.
3. A CacheLayer account/subscription is required.

## Contact

https://cachelayer.org/

## Legal

Apache License 2.0. See `LICENSE`.
