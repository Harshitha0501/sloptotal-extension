#!/usr/bin/env bash
set -e
VERSION=$(python3 -c "import json; print(json.load(open('src/manifest.json'))['version'])")
mkdir -p dist
cd src
zip -r "../dist/sloptotal-extension-v${VERSION}.zip" . -x ".*"
echo "Packaged: dist/sloptotal-extension-v${VERSION}.zip"
