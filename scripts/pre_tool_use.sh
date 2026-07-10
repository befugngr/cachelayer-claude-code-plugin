#!/usr/bin/env bash
# CacheLayer PreToolUse hook for Claude Code.
# Fail-open: any timeout, network error, or non-2xx → exit 0 (allow).
# Exit 2 would block; we only exit 2 if CacheLayer explicitly returns deny
# (not used today; hits are returned as allow + cachelayer payload).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${CACHELAYER_HOOK_URL:-https://api.cachelayer.org/hooks/pre-tool-use}"
TOKEN="${CACHELAYER_CONNECT_TOKEN:-}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-2}"

INPUT="$(cat || true)"
AUTH_ARGS=()
if [[ -n "$TOKEN" ]]; then
  AUTH_ARGS=(-H "Authorization: Bearer ${TOKEN}")
fi

RESP="$(curl -sS --max-time "$TIMEOUT" \
  -X POST "$URL" \
  -H "Content-Type: application/json" \
  "${AUTH_ARGS[@]}" \
  -d "$INPUT" 2>/dev/null || true)"

if [[ -z "$RESP" ]]; then
  # Fail-open
  exit 0
fi

# Echo CacheLayer JSON so Claude can see hit/result context on stdout.
printf '%s\n' "$RESP"

# If permissionDecision is deny, block with exit 2.
if printf '%s' "$RESP" | grep -q '"permissionDecision"[[:space:]]*:[[:space:]]*"deny"'; then
  exit 2
fi
exit 0
