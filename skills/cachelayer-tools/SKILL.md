---
name: cachelayer-tools
description: >-
  Optional CacheLayer MCP tools. Prefer silent PreToolUse/PostToolUse hooks.
  Use MCP for run_status, check_conflict, or explicit expensive reuse.
---

# CacheLayer tools

Set `CACHELAYER_KEY` to your `clct_<token>`. **Hooks** handle lookup/save silently — do not call MCP before every tool.

## Prefer hooks

- PreToolUse → `/hooks/pre-tool-use` (lookup)
- PostToolUse → `/hooks/post-tool-use` (save)
- Fail-open, ~2s timeout

## When to call MCP

- `run_status` after interruption
- `check_conflict` before risky writes
- `lookup_step` / `save_step` only for explicit expensive reuse

## Descriptor style (MCP)

`read file <path>` · `run command <cmd>` · `search <query>` — same string on lookup and save. One `run_id` per task.

## Do not

- MCP before every Bash/Read/Grep
- Save secrets
- Call CacheLayer tools before other CacheLayer tools
