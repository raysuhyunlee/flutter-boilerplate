#!/bin/bash

# Prevent sourcing - must be executed directly
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "Error: This script should be executed, not sourced."
    echo "Run: ./scripts/build.sh"
    return 1
fi

set -e

# Clean and create build-artifacts directory
rm -rf ./build-artifacts
mkdir -p ./build-artifacts

# Build Flutter app bundle
flutter build appbundle --release

# Copy AAB to build-artifacts
AAB_PATH="./build/app/outputs/bundle/release/app-release.aab"
if [[ -f "$AAB_PATH" ]]; then
    cp "$AAB_PATH" ./build-artifacts/app-release.aab
    echo "✓ AAB copied to build-artifacts"
else
    echo "Error: AAB not found at $AAB_PATH"
    exit 1
fi

# Compress debug symbols
SYMBOLS_DIR=$(find ./build/app/intermediates/merged_native_libs/release -type d -name "lib" 2>/dev/null | head -1)
if [[ -n "$SYMBOLS_DIR" && -d "$SYMBOLS_DIR" ]]; then
    (cd "$SYMBOLS_DIR" && zip -r symbols.zip ./*)
    mv "$SYMBOLS_DIR/symbols.zip" ./build-artifacts/debug-symbols.zip
    echo "✓ Debug symbols compressed"
else
    echo "Warning: debug symbols directory not found (skipping)"
fi

echo "Build complete! Artifacts in ./build-artifacts/"