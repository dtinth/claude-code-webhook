#!/bin/bash

# Claude Code Webhook Sender
# Sends events asynchronously to a configured webhook endpoint

CONFIG_FILE="$HOME/.claude-webhook/config.json"

# Debug mode - set WEBHOOK_DEBUG=1 to see what's happening
DEBUG="${WEBHOOK_DEBUG:-0}"

debug_log() {
  if [[ "$DEBUG" == "1" ]]; then
    echo "[DEBUG] $1" >&2
  fi
}

debug_log "Script started"

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  debug_log "Config file not found at $CONFIG_FILE"
  exit 0
fi

debug_log "Config file found at $CONFIG_FILE"

# Read webhook URL and enabled flag from config using jq
WEBHOOK_URL=$(jq -r '.webhook_url // empty' "$CONFIG_FILE" 2>/dev/null)
ENABLED=$(jq -r '.enabled // true' "$CONFIG_FILE" 2>/dev/null)
TIMEOUT=$(jq -r '.timeout // 60' "$CONFIG_FILE" 2>/dev/null)

debug_log "Parsed config: WEBHOOK_URL=$WEBHOOK_URL, ENABLED=$ENABLED, TIMEOUT=$TIMEOUT"

# Exit if webhook is disabled or not configured
if [[ -z "$WEBHOOK_URL" ]] || [[ "$ENABLED" != "true" ]]; then
  debug_log "Webhook disabled or no URL configured"
  exit 0
fi

debug_log "Starting to read stdin..."

# Read stdin into a temporary file to ensure data persists
# while the background curl process runs
TEMP_FILE=$(mktemp)
debug_log "Created temp file: $TEMP_FILE"

cat > "$TEMP_FILE"
STDIN_SIZE=$(wc -c < "$TEMP_FILE")
debug_log "Read $STDIN_SIZE bytes from stdin"

# Send webhook asynchronously in a detached subshell
# The subshell with & ensures the process detaches and won't create zombies
debug_log "Spawning background curl process"

(
  debug_log "Background: Starting curl request"
  curl --max-time "$TIMEOUT" --silent --show-error \
    -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    --data-binary "@$TEMP_FILE" \
    > /dev/null 2>&1

  CURL_EXIT=$?
  debug_log "Background: Curl completed with exit code $CURL_EXIT"

  # Clean up temp file after curl completes
  debug_log "Background: Removing temp file $TEMP_FILE"
  rm -f "$TEMP_FILE"
  debug_log "Background: Done"
) &

BG_PID=$!
debug_log "Spawned background process with PID $BG_PID"

# Exit immediately without waiting for curl
debug_log "Main process exiting"
exit 0
