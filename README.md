# CacheLayer for Claude Code

This plugin connects Claude Code to CacheLayer step caching over MCP, plus a PreToolUse hook that checks the cache before tools run.

Website: [https://cachelayer.org/](https://cachelayer.org/)

## Getting started

1. Add the marketplace / clone this repo.
2. Install: `/plugin install cachelayer` (or your marketplace install flow).
3. Restart Claude Code / start a new session.
4. Confirm the CacheLayer MCP server is connected and the PreToolUse hook is loaded.

MCP URL: `https://api.cachelayer.org/mcp/sse`

When auth ships, set `CACHELAYER_CONNECT_TOKEN` for the hook and add an Authorization header under the CacheLayer MCP entry without changing the URL.

## Features

- MCP tools: `lookup_step`, `save_step`, `check_conflict`, `run_status`
- PreToolUse HTTP hook (fail-open, 2s timeout)
- Skill for correct tool argument patterns

## Notes and limitations

- Hook is fail-open: if CacheLayer is down or slow, the tool call proceeds.
- A CacheLayer account/subscription is required to use this plugin once auth is enabled.
- Keep step descriptions short and consistent so lookups match saves.

## Compliance

1. **No impersonation.** This plugin is CacheLayer only. It does not present itself as Anthropic, Claude, or any other company or brand.
2. **No malicious code.** This plugin does not steal user data, modify the system without permission, or bundle malware.
3. **Transparent requirement.** A third-party CacheLayer account/subscription is required to use this plugin.

## Contact

[https://cachelayer.org/](https://cachelayer.org/)

## Legal

Licensed under the Apache License 2.0. See `LICENSE` if present in this repo, or https://www.apache.org/licenses/LICENSE-2.0
