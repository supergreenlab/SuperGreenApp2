#!/usr/bin/env bash
set -euo pipefail

echo "== Checking Flutter =="
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: flutter not found in PATH"
  echo "Install with: sudo snap install flutter --classic"
  exit 1
fi

flutter --version

echo ""
echo "== Checking ADB =="
if ! command -v adb >/dev/null 2>&1; then
  echo "ERROR: adb not found in PATH"
  exit 1
fi

adb start-server >/dev/null
adb devices

echo ""
echo "== Flutter doctor =="
flutter doctor