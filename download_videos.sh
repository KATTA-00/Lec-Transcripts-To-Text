#!/bin/bash
# Download All Videos from Google Drive
# This script downloads all lecture and tutorial videos

echo "========================================"
echo "Downloading Videos from Google Drive"
echo "========================================"
echo ""

# Configuration
VIDEOS_DIR="videos"

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

# Create videos directory
mkdir -p "$VIDEOS_DIR"

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

echo ""
echo "=========================================="
echo "IMPORTANT: Authentication Required"
echo "=========================================="
echo "These files are shared with you privately."
echo "You have two options:"
echo ""
echo "Option 1: Use gdown with cookies (Recommended)"
echo "   1. Install a browser extension to export cookies"
echo "   2. Export cookies from drive.google.com to cookies.txt"
echo "   3. Place cookies.txt in this directory"
echo ""
echo "Option 2: Manual download"
echo "   1. Download videos manually from Google Drive"
echo "   2. Place them in the videos/ folder"
echo "   3. Run ./transcribe_all.sh"
echo ""
read -p "Do you have cookies.txt ready? (y/n): " has_cookies
echo ""

if [ "$has_cookies" != "y" ] && [ "$has_cookies" != "Y" ]; then
    echo "Please download the videos manually and place them in: ./$VIDEOS_DIR/"
    echo "Then run: ./transcribe_all.sh"
    deactivate
    exit 0
fi

if [ ! -f "cookies.txt" ]; then
    echo "Error: cookies.txt not found!"
    echo "Please export your Google Drive cookies to cookies.txt"
    deactivate
    exit 1
fi

echo "✓ Found cookies.txt"

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
    gdown "https://drive.google.com/uc?id=$file_id" -O "$output_path" --cookies cookies.txt
    
    if [ $? -eq 0 ]; then
        echo "   ✓ Downloaded: $output_name"
        return 0
    else
        echo "   ✗ Failed to download: $output_name"
        echo "   Try downloading manually from: https://drive.google.com/file/d/$file_id/view"
        return 1
    fi
}

# Download all videos
echo ""
echo "=========================================="
echo "Downloading Videos"
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

# Deactivate virtual environment
deactivate

# Summary
echo ""
echo "=========================================="
echo "Download Summary"
echo "=========================================="
echo "Total videos: $total_videos"
echo "Downloaded/Existing: $downloaded"
echo "Failed: $failed_downloads"
echo ""
echo "Videos saved in: ./$VIDEOS_DIR/"
echo ""

if [ $failed_downloads -eq 0 ]; then
    echo "✅ All videos downloaded successfully!"
    echo ""
    echo "Next step: Run ./transcribe_all.sh to transcribe all videos"
else
    echo "⚠️  Some downloads failed. Check the logs above."
fi
