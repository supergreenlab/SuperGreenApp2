#!/usr/bin/env bash
set -euo pipefail

CTRL_IP="${1:-192.168.1.104}"
TARGET_TS="${2:-}"
POLL_SECONDS="${POLL_SECONDS:-5}"
MAX_POLLS="${MAX_POLLS:-60}"   # 60 * 5s = 5 min
LOG_DIR="${LOG_DIR:-/tmp/supergreenapp2-ota-tests}"
mkdir -p "$LOG_DIR"

RUN_ID="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/ota-test-${RUN_ID}.log"

log() {
  printf '[%s] %s\n' "$(date -Iseconds)" "$*" | tee -a "$LOG_FILE"
}

get_i() {
  local key="$1"
  curl -fsS --max-time 4 "http://${CTRL_IP}/i?k=${key}" 2>/dev/null || true
}

get_s() {
  local key="$1"
  curl -fsS --max-time 4 "http://${CTRL_IP}/s?k=${key}" 2>/dev/null || true
}

if [[ -z "$TARGET_TS" ]]; then
  echo "Usage: $0 <controller_ip> <target_timestamp>"
  echo "Example: $0 192.168.1.104 1775047101"
  exit 1
fi

log "Starting OTA flow test"
log "Controller IP: $CTRL_IP"
log "Target TS: $TARGET_TS"
log "Polling every ${POLL_SECONDS}s for ${MAX_POLLS} polls"
log "Log file: $LOG_FILE"

INITIAL_TS="$(get_i OTA_TIMESTAMP)"
INITIAL_TIME="$(get_i TIME)"
INITIAL_BROKER_CID="$(get_s BROKER_CLIENTID)"
INITIAL_WIFI="$(get_i WIFI_STATUS)"

log "Initial OTA_TIMESTAMP=$INITIAL_TS"
log "Initial TIME=$INITIAL_TIME"
log "Initial BROKER_CLIENTID=$INITIAL_BROKER_CID"
log "Initial WIFI_STATUS=$INITIAL_WIFI"

echo ""
echo ">>> NOW START THE OTA UPGRADE FROM THE APP UI <<<"
echo "Press ENTER when you have triggered the upgrade..."
read -r

consecutive_matches=0
last_ts=""
success=0

for i in $(seq 1 "$MAX_POLLS"); do
  current_ts="$(get_i OTA_TIMESTAMP)"
  current_time="$(get_i TIME)"
  current_broker_cid="$(get_s BROKER_CLIENTID)"
  current_wifi="$(get_i WIFI_STATUS)"

  log "Poll=$i OTA_TIMESTAMP=$current_ts TIME=$current_time BROKER_CLIENTID=$current_broker_cid WIFI_STATUS=$current_wifi"

  if [[ "$current_ts" == "$TARGET_TS" ]]; then
    if [[ "$last_ts" == "$TARGET_TS" ]]; then
      consecutive_matches=$((consecutive_matches + 1))
    else
      consecutive_matches=1
    fi
  else
    consecutive_matches=0
  fi

  last_ts="$current_ts"

  if [[ "$consecutive_matches" -ge 2 ]]; then
    if [[ -n "$current_time" && -n "$current_broker_cid" ]]; then
      log "SUCCESS: strong convergence achieved"
      success=1
      break
    else
      log "Target TS matched but controller readability not yet recovered"
    fi
  fi

  sleep "$POLL_SECONDS"
done

echo ""
if [[ "$success" -eq 1 ]]; then
  echo "=== RESULT: SUCCESS ==="
  echo "Strong convergence observed:"
  echo "- OTA_TIMESTAMP matched target twice consecutively"
  echo "- TIME readable"
  echo "- BROKER_CLIENTID non-empty"
else
  echo "=== RESULT: NOT CONVERGED / TIMEOUT ==="
  echo "No strong convergence observed within polling window."
fi

echo "Log saved at: $LOG_FILE"