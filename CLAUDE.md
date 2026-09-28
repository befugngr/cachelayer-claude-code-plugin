# CacheLayer

Silent hooks look up and save tool results. Do not call CacheLayer MCP before every Read or Grep.

## Compact instructions

When compacting history, preserve:

- Active file paths and open tasks
- Decisions and constraints still in force
- Errors still being fixed
- CacheLayer session or flow ids if present

Drop large file dumps already on disk and repeated tool outputs that are no longer needed.
