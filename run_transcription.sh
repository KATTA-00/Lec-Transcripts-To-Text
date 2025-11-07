#!/bin/bash
# Quick Run Script for Video Transcription
# This script runs the transcription with default settings

echo "========================================"
echo "Starting Video Transcription"
echo "========================================"
echo ""

# Detect Python command
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Error: Python not found!"
    exit 1
fi

# Check if transcribe_video.py exists
if [ ! -f "transcribe_video.py" ]; then
    echo "Error: transcribe_video.py not found!"
    exit 1
fi

# Check if video file exists
if [ ! -f "Lecture 1 - Computer Abstractions.mp4" ]; then
    echo "Error: Video file 'Lecture 1 - Computer Abstractions.mp4' not found!"
    exit 1
fi

# Run the transcription
echo "Running transcription script..."
echo "This may take several minutes depending on video length..."
echo ""

$PYTHON_CMD transcribe_video.py

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✓ Transcription Completed Successfully!"
    echo "========================================"
else
    echo ""
    echo "========================================"
    echo "✗ Transcription Failed"
    echo "========================================"
    exit 1
fi
