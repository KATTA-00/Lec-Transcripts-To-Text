# Video Transcription with OpenAI Whisper

This script transcribes the lecture video using OpenAI's Whisper model.

## Prerequisites

### 1. Install Python Dependencies

```powershell
pip install git+https://github.com/openai/whisper.git
```

Or use the requirements file:

```powershell
pip install -r requirements.txt
```

### 2. Install FFmpeg

**Option A - Using Chocolatey (Recommended for Windows):**

```powershell
choco install ffmpeg
```

**Option B - Using Scoop:**

```powershell
scoop install ffmpeg
```

**Option C - Manual Installation:**

1. Download FFmpeg from https://ffmpeg.org/download.html
2. Extract the files
3. Add the `bin` folder to your system PATH

**Verify installation:**

```powershell
ffmpeg -version
```

## Usage

Simply run the script:

```powershell
python transcribe_video.py
```

The script will automatically:

- Find the video file `Lecture 1 - Computer Abstractions.mp4`
- Load the Whisper model (downloads on first run, ~1.5GB for medium model)
- Transcribe the video
- Generate multiple output files

## Output Files

The script generates:

- `Lecture 1 - Computer Abstractions_transcript.txt` - Plain text transcript
- `Lecture 1 - Computer Abstractions_transcript.vtt` - WebVTT with timestamps
- `Lecture 1 - Computer Abstractions_transcript.srt` - SubRip subtitles
- `Lecture 1 - Computer Abstractions_transcript.json` - Full JSON output

## Configuration

You can modify these settings in `transcribe_video.py`:

- **MODEL_SIZE**: Choose model accuracy vs speed

  - `tiny` - Fastest, least accurate
  - `base` - Fast, basic accuracy
  - `small` - Good balance
  - `medium` - Better accuracy (default)
  - `large` - Best accuracy, slowest

- **OUTPUT_FORMAT**: Choose output types
  - `txt` - Text only
  - `vtt` - WebVTT only
  - `srt` - SRT subtitles only
  - `json` - Full JSON only
  - `all` - All formats (default)

## Notes

- First run will download the model (~1.5GB for medium)
- Transcription time varies based on video length and model size
- Medium model provides a good balance of speed and accuracy
- All data is processed locally - completely private and offline
