#!/bin/bash
# Transcribe All Videos in the videos/ folder
# Automatically finds all video files and transcribes them

echo "========================================"
echo "Batch Video Transcription"
echo "========================================"
echo ""

VIDEOS_DIR="videos"
TRANSCRIPTS_DIR="transcripts"
MODEL_SIZE="medium"  # Options: tiny, base, small, medium, large

# Check if videos directory exists
if [ ! -d "$VIDEOS_DIR" ]; then
    echo "Error: $VIDEOS_DIR directory not found!"
    echo "Please create the directory and add your video files:"
    echo "  mkdir $VIDEOS_DIR"
    echo "  # Then copy your .mp4 files to $VIDEOS_DIR/"
    exit 1
fi

# Check if there are any videos
video_count=$(find "$VIDEOS_DIR" -type f \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.webm" \) 2>/dev/null | wc -l)

if [ $video_count -eq 0 ]; then
    echo "Error: No video files found in $VIDEOS_DIR/"
    echo "Supported formats: .mp4, .avi, .mov, .mkv, .webm"
    echo ""
    echo "Please add your video files to: ./$VIDEOS_DIR/"
    exit 1
fi

echo "Found $video_count video file(s) to transcribe"
echo "Using Whisper model: $MODEL_SIZE"
echo ""

# Create transcripts directory
mkdir -p "$TRANSCRIPTS_DIR"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run ./install.sh first to set up the environment."
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

for video_file in "$VIDEOS_DIR"/*; do
    # Check if file is a video
    if [[ -f "$video_file" && "$video_file" =~ \.(mp4|avi|mov|mkv|webm|MP4|AVI|MOV|MKV|WEBM)$ ]]; then
        ((current++))
        
        # Get filename without extension
        filename=$(basename "$video_file")
        video_name="${filename%.*}"
        
        # Create directory for this video's transcripts
        transcript_dir="$TRANSCRIPTS_DIR/$video_name"
        mkdir -p "$transcript_dir"
        
        echo "=========================================="
        echo "[$current/$video_count] Transcribing: $video_name"
        echo "=========================================="
        echo "File: $filename"
        echo ""
        
        # Transcribe the video
        python batch_transcribe.py "$video_file" "$transcript_dir" "$MODEL_SIZE"
        
        if [ $? -eq 0 ]; then
            ((transcribed++))
            echo "✓ Success: $video_name"
        else
            ((failed++))
            echo "✗ Failed: $video_name"
        fi
        echo ""
    fi
done

# Deactivate virtual environment
deactivate

# Final Summary
echo "=========================================="
echo "Transcription Summary"
echo "=========================================="
echo "Total videos found: $video_count"
echo "Successfully transcribed: $transcribed"
echo "Failed: $failed"
echo ""
echo "Output location: ./$TRANSCRIPTS_DIR/"
echo ""

# Show folder structure
if [ $transcribed -gt 0 ]; then
    echo "Transcripts organized by video:"
    ls -1 "$TRANSCRIPTS_DIR" | head -5
    if [ $transcribed -gt 5 ]; then
        echo "... and $((transcribed - 5)) more"
    fi
    echo ""
fi

if [ $failed -eq 0 ]; then
    echo "✅ All videos transcribed successfully!"
else
    echo "⚠️  $failed video(s) failed. Check the logs above for details."
fi
