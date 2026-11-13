#!/usr/bin/env bash
# Builds dist/restaurant-picker.zip for uploading as a custom skill in the Claude app.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/restaurant-picker.zip
(cd skills && zip -r ../dist/restaurant-picker.zip restaurant-picker -x '*/taste-profile.md' '*.DS_Store')
echo "Built dist/restaurant-picker.zip"
