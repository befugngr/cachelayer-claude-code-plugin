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
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-0.5}"

FLOW_HDR=()
if [[ -n "${CACHELAYER_FLOW_ID:-}" ]]; then
  FLOW_HDR=(-H "x-cachelayer-flow: ${CACHELAYER_FLOW_ID}")
fi


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
  "${FLOW_HDR[@]}" \
  -d "$INPUT" 2>/dev/null || true)"

if [[ -z "$RESP" ]]; then
  # Fail-open
  exit 0
fi

# On a hit, replace the tool result and stop the tool. On a miss, say nothing.
if command -v python3 >/dev/null 2>&1; then
  OUT="$(printf '%s' "$RESP" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    raise SystemExit(0)
if not isinstance(d, dict) or d.get("error"):
    raise SystemExit(0)
cl = d.get("cachelayer") if isinstance(d.get("cachelayer"), dict) else {}
hso = d.get("hookSpecificOutput") if isinstance(d.get("hookSpecificOutput"), dict) else {}
hit = bool((d.get("hit") or cl.get("hit")) and cl.get("replay_safe") is True)
result = d.get("updatedToolOutput")
if result is None:
    result = d.get("result") if d.get("result") is not None else cl.get("result")
if not (hit and result is not None):
    raise SystemExit(0)
out = {
    "continue": False,
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": hso.get("permissionDecisionReason") or "cache_hit",
        "additionalContext": hso.get("additionalContext") or "",
    },
    "updatedToolOutput": result,
}
print(json.dumps(out))
raise SystemExit(2)
' 2>/dev/null)"
  RC=$?
  if [[ "$RC" -eq 2 && -n "$OUT" ]]; then
    printf '%s\n' "$OUT"
    exit 2
  fi
fi
exit 0
