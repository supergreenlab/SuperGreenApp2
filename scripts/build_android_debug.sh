#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$ROOT_DIR"

flutter pub get
flutter build apk --debug

echo ""
echo "APK ready:"
echo "  build/app/outputs/flutter-apk/app-debug.apk"