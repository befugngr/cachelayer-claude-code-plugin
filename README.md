# CacheLayer for Claude Code

MCP step cache plus a PreToolUse hook so Claude Code can reuse prior safe agent steps.

Site: https://cachelayer.org/

## Prerequisites

- [Claude Code](https://code.claude.com/)
- A **CacheLayer account** and connect token (`clct_…`) — required; MCP returns **401** without it

## 1. Get a connect token

1. Sign up or sign in at https://cachelayer.org/
2. Create a connect token from your account (API: `POST /user/connect-token` while logged in)
3. Copy the full value once — it looks like `clct_<your-token>`

You will set this as `CACHELAYER_KEY` in the next steps.

## 2. Install

In Claude Code:

```text
/plugin marketplace add befugngr/cachelayer-claude-code-plugin
/plugin install cachelayer@cachelayer-claude-code-plugin
/reload-plugins
```

(`/reload-plugins` reloads plugins in-session; you can also restart Claude Code.)

Local test without a marketplace:

```bash
claude --plugin-dir ./cachelayer-claude-code-plugin
```

## 3. Auth (required)

Export your connect token in the environment that launches Claude Code:

```bash
export CACHELAYER_KEY='clct_<your-token>'
```

The bundled `.mcp.json` and `scripts/pre_tool_use.sh` both send:

`Authorization: Bearer <CACHELAYER_KEY>`

- MCP URL: `https://api.cachelayer.org/mcp` (streamable HTTP)
- Hook URL: `https://api.cachelayer.org/hooks/pre-tool-use` (fail-open, 5s timeout)

Missing or invalid token → MCP **401**. Hook fail-opens (tool still runs; no cache).

## 4. Verify

- MCP server `cachelayer` is connected
- Tools available: `lookup_step`, `save_step`, `check_conflict`, `run_status`
- Skill `cachelayer-tools` is loaded
- A test `lookup_step` does not return unauthorized / 401

## Tools

- `lookup_step` / `save_step` / `check_conflict` / `run_status`
- PreToolUse hook: command script → CacheLayer hook API (not a native HTTP hook type)

One UUID `run_id` per task. Keep descriptors short and consistent (e.g. `read file src/auth.js`).

## Layout

```text
.claude-plugin/plugin.json       — manifest
.claude-plugin/marketplace.json  — marketplace entry
.mcp.json                        — MCP server config
hooks/hooks.json                 — PreToolUse definition
scripts/pre_tool_use.sh          — hook handler
skills/cachelayer-tools/SKILL.md — agent skill
LICENSE
README.md
```

## Limits

- Hook fail-open on downtime / timeout / non-2xx (including 401)
- Write/mutating steps are not replayed from cache
- Do not save secrets from env files

## Compliance

1. No impersonation. CacheLayer only; not Anthropic or Claude.
2. No malicious code.
3. A CacheLayer account/subscription is required.

## Contact

https://cachelayer.org/

## Legal

Apache License 2.0. See `LICENSE`.
