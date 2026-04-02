#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$ROOT_DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: flutter not found"
  exit 1
fi

flutter pub get

DEVICE_ID="${1:-}"

if [[ -z "$DEVICE_ID" ]]; then
  echo "Available Flutter devices:"
  flutter devices
  echo ""
  echo "Usage:"
  echo "  $0 <device_id>"
  echo ""
  echo "No device_id provided, trying plain flutter run..."
  flutter run
else
  flutter run -d "$DEVICE_ID"
fi