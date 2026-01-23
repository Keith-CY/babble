# Babble

A macOS voice input tool that uses MLX Whisper for local speech-to-text transcription and Apple Foundation Models for on-device text refinement.

## Requirements

- macOS 26+ (Tahoe)
- Apple Silicon Mac

## Installation

### From GitHub Releases

1. Download `Babble-vX.X.X.zip` from [Releases](https://github.com/louzhixian/babble/releases)
2. Unzip and move `Babble.app` to `/Applications`
3. **First Launch Security**:

   Since the app is not notarized, macOS will block it on first launch:

   - Double-click `Babble.app` - you'll see a warning dialog
   - Open **System Settings > Privacy & Security**
   - Scroll down to **Security** section
   - Click **"Open Anyway"** next to the Babble message
   - Click **"Open"** in the confirmation dialog

4. Grant permissions when prompted:
   - **Microphone**: Required for voice recording
   - **Accessibility**: Required for pasting text (Cmd+V simulation)

### Troubleshooting Permissions

If accessibility permissions show the wrong app path:

```bash
# Reset accessibility permissions for Babble
tccutil reset Accessibility com.babble.app

# Reset microphone permissions for Babble
tccutil reset Microphone com.babble.app
```

Then relaunch the app and grant permissions again.

## Usage

1. Press **Option+Space** to start/stop recording (or hold for push-to-talk)
2. Speak into your microphone
3. Text will be transcribed and pasted into the active application

## Building from Source

### Swift App

```bash
cd BabbleApp
swift build -c release
./build-app.sh
```

### Whisper Service

The whisper-service is downloaded automatically on first launch. For development:

```bash
cd whisper-service
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python server.py
```

## License

MIT
