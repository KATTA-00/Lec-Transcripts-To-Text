#!/bin/bash
# Batch Video Transcription Script with Google Drive Download
# Downloads videos from Google Drive and transcribes them using Whisper

echo "========================================"
echo "Batch Video Transcription with Download"
echo "========================================"
echo ""

# Configuration
VIDEOS_DIR="videos"
TRANSCRIPTS_DIR="transcripts"
MODEL_SIZE="medium"  # Options: tiny, base, small, medium, large

# Google Drive file IDs and names
declare -A DRIVE_FILES=(
    ["1Eo5iaFIz-ikSMxmPuWEzcFPMMIS5bgzr"]="Lecture_01.mp4"
    ["1cQy9cXOLETwFGo6UJUtL_1xpMKCYFVzf"]="Lecture_02.mp4"
    ["1Hp-4yJROKE9smL8rvswXXUxXv1J1ctGk"]="Lecture_03.mp4"
    ["1Yat-kM1lV7EpG2QdnMxHjsk6YBuSCrk1"]="Tutorial_04.mp4"
    ["1orJuQFGAy5CDmu14cZiItOPNinZygcgA"]="Tutorial_05.mp4"
    ["1vrKJ5_WgRbC5l5XjWkUoBvfz55x3Hqr5"]="Tutorial_06.mp4"
    ["1Y-61Epav2np9IBmAFQihhQBCmrqM_lUE"]="Tutorial_07.mp4"
    ["15lfF_-0Fce4mxBQU3r3glcznPUyCV38f"]="Lecture_08.mp4"
    ["1tMTE2TYhmsH7VO1_AxJzkZ_3peZhxgnn"]="Lecture_09.mp4"
    ["19woyuFvE9pgryorz6Ju4RwXWQv2a5N9N"]="Lecture_10.mp4"
    ["1uTXnkpnOlFTT5EWz2hOLTOQ6jVXW5eXk"]="Lecture_11.mp4"
    ["1DvdO12yVTrK17CTLXWKJZPKw0aDpvyBG"]="Lecture_12.mp4"
    ["1Ui_xGGaNbuZU7ce0fm6w5CIhJDMqHEBJ"]="Lecture_13.mp4"
    ["1U_RifIRGkA_wHgahL_Nc_7QLSaf3ESTg"]="Lecture_14.mp4"
    ["1MuLvNbGOrDBz4cYWZxdlLZ0K5yNpEb7y"]="Lecture_15.mp4"
    ["1HjPjSmfHNbOFXHGT6iWYdpdOyK0f6SDw"]="Lecture_16.mp4"
    ["19y2d5O8EfbwUwObWW_j3VNdienSiH5Pt"]="Lecture_17.mp4"
    ["112nGDWIh4kWnXbCjN9QCtEcCVuwf-c4G"]="Lecture_18.mp4"
    ["1IAxOPpl-YPtC5jCpeNfiF9oH2-iZ00QE"]="Lecture_19.mp4"
    ["1rnA8PIB445TnJSZzIf2mtjp77RUojSyv"]="Lecture_20.mp4"
    ["13Ly1XFstSnW2hLY4LXI8NHaTfM3BmGu8"]="Lecture_21.mp4"
)

# Create directories
mkdir -p "$VIDEOS_DIR"
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

# Check if gdown is installed, if not install it
echo ""
echo "Checking for gdown (Google Drive downloader)..."
if ! python -c "import gdown" 2>/dev/null; then
    echo "Installing gdown..."
    pip install gdown
    echo "✓ gdown installed"
else
    echo "✓ gdown already installed"
fi

# Function to download file from Google Drive
download_video() {
    local file_id=$1
    local output_name=$2
    local output_path="$VIDEOS_DIR/$output_name"
    
    if [ -f "$output_path" ]; then
        echo "   ✓ Already exists: $output_name"
        return 0
    fi
    
    echo "   Downloading: $output_name"
    gdown "https://drive.google.com/uc?id=$file_id" -O "$output_path" --quiet
    
    if [ $? -eq 0 ]; then
        echo "   ✓ Downloaded: $output_name"
        return 0
    else
        echo "   ✗ Failed to download: $output_name"
        return 1
    fi
}

# Function to transcribe video
transcribe_video() {
    local video_path=$1
    local video_name=$(basename "$video_path" .mp4)
    local transcript_dir="$TRANSCRIPTS_DIR/$video_name"
    
    # Create directory for this video's transcripts
    mkdir -p "$transcript_dir"
    
    echo ""
    echo "=========================================="
    echo "Transcribing: $video_name"
    echo "=========================================="
    
    python batch_transcribe.py "$video_path" "$transcript_dir" "$MODEL_SIZE"
    
    if [ $? -eq 0 ]; then
        echo "✓ Transcription complete: $video_name"
        return 0
    else
        echo "✗ Transcription failed: $video_name"
        return 1
    fi
}

# Download all videos
echo ""
echo "=========================================="
echo "Step 1: Downloading Videos"
echo "=========================================="
echo ""

total_videos=${#DRIVE_FILES[@]}
downloaded=0
failed_downloads=0

for file_id in "${!DRIVE_FILES[@]}"; do
    output_name="${DRIVE_FILES[$file_id]}"
    download_video "$file_id" "$output_name"
    if [ $? -eq 0 ]; then
        ((downloaded++))
    else
        ((failed_downloads++))
    fi
done

echo ""
echo "Download Summary:"
echo "   Total videos: $total_videos"
echo "   Downloaded/Existing: $downloaded"
echo "   Failed: $failed_downloads"

# Transcribe all videos
echo ""
echo "=========================================="
echo "Step 2: Transcribing Videos"
echo "=========================================="

transcribed=0
failed_transcriptions=0

for video_file in "$VIDEOS_DIR"/*.mp4; do
    if [ -f "$video_file" ]; then
        transcribe_video "$video_file"
        if [ $? -eq 0 ]; then
            ((transcribed++))
        else
            ((failed_transcriptions++))
        fi
    fi
done

# Deactivate virtual environment
deactivate

# Final summary
echo ""
echo "=========================================="
echo "Final Summary"
echo "=========================================="
echo "Videos downloaded: $downloaded/$total_videos"
echo "Videos transcribed: $transcribed"
echo "Failed transcriptions: $failed_transcriptions"
echo ""
echo "Transcripts saved in: ./$TRANSCRIPTS_DIR/"
echo "Videos saved in: ./$VIDEOS_DIR/"
echo ""

if [ $failed_transcriptions -eq 0 ] && [ $failed_downloads -eq 0 ]; then
    echo "✅ All operations completed successfully!"
else
    echo "⚠️  Some operations failed. Check the logs above."
fi
