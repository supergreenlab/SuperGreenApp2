#!/bin/bash

AAB="../build/app/outputs/bundle/release/app-release.aab"
APK="supergreenapp.apk"
if [ "$#" -ge 1 ]; then
  AAB="$1"
fi
if [ "$#" -ge 2 ]; then
  APK="$2"
fi

if [ ! -f keystore.properties ]; then
  echo "Missing keystore.properties file"
  exit
fi

declare -A props
while IFS='=' read -r k v; do
  props["$k"]="$v"
done < keystore.properties

java -jar ./bundletool-all-0.13.3.jar build-apks --bundle "$AAB" --output app-release.apks --ks ../android/android-keystore/release-key.keystore --ks-key-alias sga --ks-pass "pass:${props[password]}" --key-pass "pass:${props[password]}" --mode=universal
unzip -p app-release.apks universal.apk > $APK
rm -rf app-release.apks
