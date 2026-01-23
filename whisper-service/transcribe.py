"""MLX Whisper transcription module."""

import time
from pathlib import Path
from typing import Optional

import mlx_whisper


class Transcriber:
    """Handles MLX Whisper model loading and transcription."""

    def __init__(self, model_name: str = "mlx-community/whisper-large-v3-turbo"):
        self.model_name = model_name
        self._model_loaded = False
        self._last_used: float = 0

    @property
    def is_loaded(self) -> bool:
        """Check if model is loaded."""
        return self._model_loaded

    def load_model(self) -> None:
        """
        Explicitly load the model (downloads if not cached).
        This is a blocking operation that may take a while on first run.
        """
        if self._model_loaded:
            print(f"load_model: already loaded")
            return

        print(f"load_model: starting for model {self.model_name}")

        # mlx_whisper.transcribe will download and load the model
        # We use a minimal audio to trigger this
        import tempfile
        import struct
        import wave

        # Create a minimal silent WAV file (16kHz, 0.1 seconds, mono, 16-bit)
        sample_rate = 16000
        duration = 0.1
        num_samples = int(sample_rate * duration)

        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
            tmp_path = tmp.name

        print(f"load_model: creating temp WAV file at {tmp_path}")

        # Write WAV file manually (no external dependencies)
        with wave.open(tmp_path, 'wb') as wav_file:
            wav_file.setnchannels(1)  # Mono
            wav_file.setsampwidth(2)  # 16-bit
            wav_file.setframerate(sample_rate)
            # Write silent samples (all zeros)
            silent_data = struct.pack('<' + 'h' * num_samples, *([0] * num_samples))
            wav_file.writeframes(silent_data)

        print(f"load_model: WAV file created, calling mlx_whisper.transcribe")

        try:
            # This triggers model download and loading
            mlx_whisper.transcribe(
                tmp_path,
                path_or_hf_repo=self.model_name,
                language="en",
            )
            self._model_loaded = True
            print(f"load_model: model loaded successfully")
        finally:
            Path(tmp_path).unlink(missing_ok=True)

        self._last_used = time.time()

    def ensure_loaded(self) -> None:
        """Ensure model is loaded (lazy loading on first use)."""
        if not self._model_loaded:
            self.load_model()
        self._last_used = time.time()

    def transcribe(
        self,
        audio_path: Path,
        language: str = "zh",
    ) -> dict:
        """
        Transcribe audio file to text.

        Args:
            audio_path: Path to audio file (wav, m4a, mp3)
            language: Language code for transcription

        Returns:
            dict with keys: text, segments, duration, processing_time
        """
        self.ensure_loaded()

        start_time = time.time()

        result = mlx_whisper.transcribe(
            str(audio_path),
            path_or_hf_repo=self.model_name,
            language=language,
        )

        processing_time = time.time() - start_time

        return {
            "text": result.get("text", "").strip(),
            "segments": result.get("segments", []),
            "language": result.get("language", language),
            "processing_time": round(processing_time, 3),
        }

    @property
    def idle_seconds(self) -> float:
        """Seconds since last use."""
        if self._last_used == 0:
            return 0
        return time.time() - self._last_used

    def unload(self) -> None:
        """Unload model to free memory."""
        # mlx_whisper doesn't have explicit unload, but we can reset state
        self._model_loaded = False
        self._last_used = 0


# Global instance
_transcriber: Optional[Transcriber] = None


def get_transcriber(model_name: str = "mlx-community/whisper-large-v3-turbo") -> Transcriber:
    """Get or create global transcriber instance."""
    global _transcriber
    if _transcriber is None:
        _transcriber = Transcriber(model_name)
    return _transcriber
