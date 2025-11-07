#!/bin/bash
# Installation Script for Video Transcription
# Run this script on Linux/Mac
# This script creates a virtual environment to avoid system package conflicts

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
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    echo "   ✓ Python found: $PYTHON_VERSION"
    PYTHON_CMD="python"
else
    echo "   ✗ Python not found! Please install Python first."
    exit 1
fi

# Check for python3-venv on Debian/Ubuntu systems
echo ""
echo "2. Checking for venv support..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        if ! $PYTHON_CMD -m venv --help &> /dev/null; then
            echo "   Installing python3-venv..."
            sudo apt-get update
            sudo apt-get install -y python3-venv python3-full
        fi
    fi
fi
echo "   ✓ Virtual environment support available"

# Check FFmpeg installation
echo ""
echo "3. Checking FFmpeg installation..."
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

# Create virtual environment
echo ""
echo "4. Creating virtual environment..."
VENV_DIR="venv"
if [ -d "$VENV_DIR" ]; then
    echo "   ✓ Virtual environment already exists"
else
    echo "   Creating new virtual environment..."
    $PYTHON_CMD -m venv $VENV_DIR
    echo "   ✓ Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "5. Activating virtual environment..."
source $VENV_DIR/bin/activate
echo "   ✓ Virtual environment activated"

# Upgrade pip in virtual environment
echo ""
echo "6. Upgrading pip..."
pip install --upgrade pip

# Install Python packages
echo ""
echo "7. Installing OpenAI Whisper..."
echo "   This may take a few minutes and will download ~1-2GB..."
pip install git+https://github.com/openai/whisper.git

echo ""
echo "8. Installing additional dependencies..."
pip install ffmpeg-python numpy torch

echo ""
echo "9. Installing Sumy for summarization..."
pip install sumy nltk
echo "Downloading NLTK data..."
python -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab')"
echo "✓ Sumy installed"

# Verify installations
echo ""
echo "10. Verifying installations..."
if python -c "import whisper" 2>/dev/null; then
    echo "   ✓ Whisper installed successfully"
else
    echo "   ✗ Whisper installation failed"
    deactivate
    exit 1
fi

# Create activation helper script
echo ""
echo "11. Creating helper scripts..."
cat > activate_env.sh << 'EOF'
#!/bin/bash
# Helper script to activate the virtual environment
source venv/bin/activate
echo "Virtual environment activated!"
echo "Run: python transcribe_video.py"
EOF
chmod +x activate_env.sh
echo "   ✓ Created activate_env.sh helper script"

deactivate

echo ""
echo "========================================"
echo "✓ Installation Complete!"
echo "========================================"
echo ""
echo "To use the transcription script:"
echo "   1. Activate virtual environment: source venv/bin/activate"
echo "   2. Run transcription: python transcribe_video.py"
echo "   3. Deactivate when done: deactivate"
echo ""
echo "Or simply run: source activate_env.sh"
echo ""
