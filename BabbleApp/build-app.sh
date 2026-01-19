#!/bin/bash
# Build Babble.app bundle with proper Info.plist and whisper-service

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Build release
swift build -c release

# Create app bundle structure
APP_DIR=".build/Babble.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
cp .build/release/Babble "$MACOS_DIR/"

# Copy Info.plist
cp Info.plist "$CONTENTS_DIR/"

# Copy whisper-service
cp -r "$PROJECT_DIR/whisper-service" "$RESOURCES_DIR/"

echo "Built Babble.app at $APP_DIR"
echo "Note: whisper-service bundled in Resources/"
