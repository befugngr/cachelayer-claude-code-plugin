---
name: cachelayer-tools
description: >-
  Optional CacheLayer cache and local CRITIC/TIA/Debug tools. Prefer silent
  PreToolUse/PostToolUse cache hooks; use local loop-cutters once.
---

# CacheLayer tools

Set `CACHELAYER_KEY` to your `clct_<token>`. Hooks handle ordinary remote cache lookup/save silently; do not call MCP before every tool.

## Local loop-cutters

- Call `verify_edit` **once after a coherent code edit** with edited paths. It gates typecheck, lint, then affected tests. Skip docs-only changes.
- Call `run_affected_tests` **once after edits** when targeted test evidence is needed and `verify_edit` did not already run tests.
- `debug_failure` — call once after a real failure with its traceback/output. For verified minimization, also pass `failing_input` and bounded `repro.argv`; do not start a second debug loop.
- Optional analyzers degrade to bounded stdlib or project-tool fallbacks and return install guidance instead of crashing.

## Remote cache MCP

Use `run_status` after interruption, `check_conflict` before risky writes, and `lookup_step` / `save_step` only for explicit expensive reuse. Use stable lowercase descriptors and one `run_id` per task.

## Do not

- MCP before every Bash/Read/Grep
- Save secrets
- Nest CacheLayer tool calls
