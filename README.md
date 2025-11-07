# Batch Video Transcription with OpenAI Whisper

Automatically transcribe multiple lecture videos using OpenAI's Whisper model.

## 🚀 Quick Start

### 1. Install Dependencies

```bash
./install.sh
```

This will:

- Create a virtual environment
- Install Whisper and all dependencies
- Install FFmpeg if needed

### 2. Add Your Videos

```bash
mkdir videos
# Copy your video files (.mp4, .avi, .mov, .mkv, .webm) to the videos/ folder
```

### 3. Transcribe All Videos

```bash
./transcribe_all.sh
```

## 📁 Output Structure

Transcripts are organized in separate folders for each video:

```
transcripts/
├── Lecture_01/
│   ├── Lecture_01.txt      # Plain text transcript
│   ├── Lecture_01.vtt      # WebVTT with timestamps
│   ├── Lecture_01.srt      # SubRip subtitles
│   └── Lecture_01.json     # Full JSON output
├── Lecture_02/
│   ├── Lecture_02.txt
│   ├── Lecture_02.vtt
│   ├── Lecture_02.srt
│   └── Lecture_02.json
└── ... (one folder per video)
```

## ⚙️ Configuration

Edit `transcribe_all.sh` or `batch_transcribe.py` to change:

**MODEL_SIZE**: Choose accuracy vs speed

- `tiny` - Fastest, least accurate
- `base` - Fast, basic accuracy
- `small` - Good balance
- `medium` - Better accuracy (default) ✅
- `large` - Best accuracy, slowest

## 📝 Supported Video Formats

- `.mp4`
- `.avi`
- `.mov`
- `.mkv`
- `.webm`

## 🔧 Scripts

- **`install.sh`** - One-time setup (creates virtual environment, installs dependencies)
- **`transcribe_all.sh`** - Transcribe all videos in `videos/` folder
- **`batch_transcribe.py`** - Core transcription logic (used by shell script)
- **`transcribe_video.py`** - Single video transcription (legacy)

## 💡 Tips

- First run downloads the Whisper model (~1.5GB for medium)
- Transcription time: ~10-20 minutes per hour of video (medium model)
- All processing is local and offline - completely private
- Can pause and resume - already transcribed videos are skipped

## 🐛 Troubleshooting

**No videos found:**

```bash
mkdir videos
# Add your video files to videos/ folder
```

**Virtual environment error:**

```bash
./install.sh
```

**FFmpeg not found:**

```bash
sudo apt install ffmpeg  # Linux
brew install ffmpeg      # Mac
```
