#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$ROOT_DIR"

APK="build/app/outputs/flutter-apk/app-debug.apk"

if [[ ! -f "$APK" ]]; then
  echo "ERROR: APK not found at $APK"
  echo "Run: ./scripts/build_android_debug.sh"
  exit 1
fi

DEVICE_ID="${1:-}"

if [[ -z "$DEVICE_ID" ]]; then
  adb install -r "$APK"
else
  adb -s "$DEVICE_ID" install -r "$APK"
fi

echo "Install complete."