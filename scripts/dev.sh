#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Starting Babble development environment..."

# Start Whisper service in background
echo "Starting Whisper service..."
cd "$PROJECT_DIR/whisper-service"
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
else
    source .venv/bin/activate
fi

python server.py &
WHISPER_PID=$!
echo "Whisper service started (PID: $WHISPER_PID)"

# Wait for service to be ready
sleep 3

# Build and run Swift app
echo "Building and running Babble app..."
cd "$PROJECT_DIR/BabbleApp"
swift run

# Cleanup
echo "Stopping Whisper service..."
kill $WHISPER_PID 2>/dev/null || true

echo "Done."
