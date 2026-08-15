#!/usr/bin/env bash
# CacheLayer PreToolUse hook for Claude Code.
# Fail-open: any timeout, network error, or non-2xx → exit 0 (allow).
# Exit 2 would block; we only exit 2 if CacheLayer explicitly returns deny
# (not used today; hits are returned as allow + cachelayer payload).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${CACHELAYER_HOOK_URL:-https://api.cachelayer.org/hooks/pre-tool-use}"
# Canonical: CACHELAYER_KEY (legacy CONNECT_TOKEN / TOKEN still accepted)
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-2}"

if [[ -z "$TOKEN" ]] || ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

INPUT="$(python3 "$ROOT/scripts/filter_hook_payload.py" || true)"
if [[ -z "$INPUT" ]]; then
  exit 0
fi

RESP="$(curl -sS --max-time "$TIMEOUT" \
  -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "$INPUT" 2>/dev/null || true)"

if [[ -z "$RESP" ]]; then
  # Fail-open
  exit 0
fi

# Echo CacheLayer JSON so Claude can see hit/result context on stdout.
printf '%s\n' "$RESP"

# Parse JSON properly (grep breaks on whitespace/key order).
DECISION="allow"
if command -v python3 >/dev/null 2>&1; then
  DECISION="$(printf '%s' "$RESP" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    print("allow")
    raise SystemExit(0)
if not isinstance(d, dict):
    print("allow")
    raise SystemExit(0)
hso = d.get("hookSpecificOutput") if isinstance(d.get("hookSpecificOutput"), dict) else {}
cl = d.get("cachelayer") if isinstance(d.get("cachelayer"), dict) else {}
decision = hso.get("permissionDecision") or d.get("permissionDecision") or "allow"
print("deny" if decision == "deny" and cl.get("hit") and cl.get("replay_safe") is True else "allow")
' 2>/dev/null || echo allow)"
elif command -v jq >/dev/null 2>&1; then
  DECISION="$(printf '%s' "$RESP" | jq -r '.hookSpecificOutput.permissionDecision // .permissionDecision // "allow"' 2>/dev/null || echo allow)"
fi

if [ "$DECISION" = "deny" ]; then
  exit 2
fi
exit 0
