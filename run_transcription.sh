#!/bin/bash
# Quick Run Script for Video Transcription
# This script runs the transcription with default settings using the virtual environment

echo "========================================"
echo "Starting Video Transcription"
echo "========================================"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run ./install.sh first to set up the environment."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if transcribe_video.py exists
if [ ! -f "transcribe_video.py" ]; then
    echo "Error: transcribe_video.py not found!"
    deactivate
    exit 1
fi

# Check if video file exists
if [ ! -f "Lecture 1 - Computer Abstractions.mp4" ]; then
    echo "Error: Video file 'Lecture 1 - Computer Abstractions.mp4' not found!"
    deactivate
    exit 1
fi

# Run the transcription
echo "Running transcription script..."
echo "This may take several minutes depending on video length..."
echo ""

python transcribe_video.py

EXIT_CODE=$?

# Deactivate virtual environment
deactivate

if [ $EXIT_CODE -eq 0 ]; then
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
