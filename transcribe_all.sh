#!/bin/bash
# Transcribe All Videos in the videos/ folder
# Use this after downloading videos with download_videos.sh

echo "========================================"
echo "Transcribing All Videos"
echo "========================================"
echo ""

VIDEOS_DIR="videos"
TRANSCRIPTS_DIR="transcripts"
MODEL_SIZE="medium"  # Options: tiny, base, small, medium, large

# Check if videos directory exists
if [ ! -d "$VIDEOS_DIR" ]; then
    echo "Error: $VIDEOS_DIR directory not found!"
    echo "Please run ./download_videos.sh first to download the videos."
    exit 1
fi

# Check if there are any videos
video_count=$(ls -1 "$VIDEOS_DIR"/*.mp4 2>/dev/null | wc -l)
if [ $video_count -eq 0 ]; then
    echo "Error: No .mp4 files found in $VIDEOS_DIR/"
    echo "Please run ./download_videos.sh first to download the videos."
    exit 1
fi

echo "Found $video_count video(s) to transcribe"
echo "Using model: $MODEL_SIZE"
echo ""

# Create transcripts directory
mkdir -p "$TRANSCRIPTS_DIR"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run ./install.sh first."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Transcribe each video
transcribed=0
failed=0
current=0

for video_file in "$VIDEOS_DIR"/*.mp4; do
    if [ -f "$video_file" ]; then
        ((current++))
        video_name=$(basename "$video_file" .mp4)
        transcript_dir="$TRANSCRIPTS_DIR/$video_name"
        
        mkdir -p "$transcript_dir"
        
        echo "=========================================="
        echo "[$current/$video_count] Transcribing: $video_name"
        echo "=========================================="
        
        python batch_transcribe.py "$video_file" "$transcript_dir" "$MODEL_SIZE"
        
        if [ $? -eq 0 ]; then
            ((transcribed++))
        else
            ((failed++))
        fi
        echo ""
    fi
done

# Deactivate virtual environment
deactivate

# Summary
echo "=========================================="
echo "Transcription Summary"
echo "=========================================="
echo "Total videos: $video_count"
echo "Successfully transcribed: $transcribed"
echo "Failed: $failed"
echo ""
echo "Transcripts saved in: ./$TRANSCRIPTS_DIR/"
echo ""

if [ $failed -eq 0 ]; then
    echo "✅ All videos transcribed successfully!"
else
    echo "⚠️  Some transcriptions failed. Check the logs above."
fi
