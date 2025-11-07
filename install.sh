#!/bin/bash
# Installation Script for Video Transcription
# Run this script on Linux/Mac

echo "========================================"
echo "Video Transcription Setup Script"
echo "========================================"
echo ""

# Check Python installation
echo "1. Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "   ✓ Python found: $PYTHON_VERSION"
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    echo "   ✓ Python found: $PYTHON_VERSION"
    PYTHON_CMD="python"
    PIP_CMD="pip"
else
    echo "   ✗ Python not found! Please install Python first."
    exit 1
fi

# Check FFmpeg installation
echo ""
echo "2. Checking FFmpeg installation..."
if command -v ffmpeg &> /dev/null; then
    FFMPEG_VERSION=$(ffmpeg -version | head -n 1)
    echo "   ✓ FFmpeg found: $FFMPEG_VERSION"
else
    echo "   ✗ FFmpeg not found! Installing..."
    
    # Detect OS and install accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "   Using apt-get to install FFmpeg..."
            sudo apt-get update
            sudo apt-get install -y ffmpeg
        elif command -v yum &> /dev/null; then
            echo "   Using yum to install FFmpeg..."
            sudo yum install -y ffmpeg
        elif command -v dnf &> /dev/null; then
            echo "   Using dnf to install FFmpeg..."
            sudo dnf install -y ffmpeg
        else
            echo "   Please install FFmpeg manually: sudo apt install ffmpeg"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            echo "   Using Homebrew to install FFmpeg..."
            brew install ffmpeg
        else
            echo "   Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
    fi
fi

# Upgrade pip
echo ""
echo "3. Upgrading pip..."
$PYTHON_CMD -m pip install --upgrade pip

# Install Python packages
echo ""
echo "4. Installing OpenAI Whisper..."
echo "   This may take a few minutes and will download ~1-2GB..."
$PIP_CMD install git+https://github.com/openai/whisper.git

echo ""
echo "5. Installing additional dependencies..."
$PIP_CMD install ffmpeg-python numpy torch

# Verify installations
echo ""
echo "6. Verifying installations..."
if $PYTHON_CMD -c "import whisper" 2>/dev/null; then
    echo "   ✓ Whisper installed successfully"
else
    echo "   ✗ Whisper installation failed"
    exit 1
fi

echo ""
echo "========================================"
echo "✓ Installation Complete!"
echo "========================================"
echo ""
echo "You can now run the transcription script:"
echo "   $PYTHON_CMD transcribe_video.py"
echo ""
