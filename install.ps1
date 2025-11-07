# Installation Script for Video Transcription
# Run this script on Windows/PowerShell
# This script creates a virtual environment to avoid system package conflicts

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Video Transcription Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python installation
Write-Host "1. Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "   ✓ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Python not found! Please install Python first." -ForegroundColor Red
    Write-Host "   Download from: https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}

# Check FFmpeg installation
Write-Host ""
Write-Host "2. Checking FFmpeg installation..." -ForegroundColor Yellow
try {
    $ffmpegVersion = ffmpeg -version 2>&1 | Select-Object -First 1
    Write-Host "   ✓ FFmpeg found: $ffmpegVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ FFmpeg not found!" -ForegroundColor Red
    Write-Host "   Installing FFmpeg..." -ForegroundColor Yellow
    
    # Try Chocolatey
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "   Using Chocolatey to install FFmpeg..." -ForegroundColor Yellow
        choco install ffmpeg -y
    }
    # Try Scoop
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "   Using Scoop to install FFmpeg..." -ForegroundColor Yellow
        scoop install ffmpeg
    }
    else {
        Write-Host "   Please install FFmpeg manually:" -ForegroundColor Red
        Write-Host "   Option 1: Install Chocolatey, then run: choco install ffmpeg" -ForegroundColor Yellow
        Write-Host "   Option 2: Install Scoop, then run: scoop install ffmpeg" -ForegroundColor Yellow
        Write-Host "   Option 3: Download from https://ffmpeg.org/download.html" -ForegroundColor Yellow
        exit 1
    }
}

# Create virtual environment
Write-Host ""
Write-Host "3. Creating virtual environment..." -ForegroundColor Yellow
$venvDir = "venv"
if (Test-Path $venvDir) {
    Write-Host "   ✓ Virtual environment already exists" -ForegroundColor Green
} else {
    Write-Host "   Creating new virtual environment..." -ForegroundColor Yellow
    python -m venv $venvDir
    Write-Host "   ✓ Virtual environment created" -ForegroundColor Green
}

# Activate virtual environment
Write-Host ""
Write-Host "4. Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"
Write-Host "   ✓ Virtual environment activated" -ForegroundColor Green

# Upgrade pip
Write-Host ""
Write-Host "5. Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install Python packages
Write-Host ""
Write-Host "6. Installing OpenAI Whisper..." -ForegroundColor Yellow
Write-Host "   This may take a few minutes and will download ~1-2GB..." -ForegroundColor Cyan
pip install git+https://github.com/openai/whisper.git

Write-Host ""
Write-Host "7. Installing additional dependencies..." -ForegroundColor Yellow
pip install ffmpeg-python numpy torch

# Verify installations
Write-Host ""
Write-Host "8. Verifying installations..." -ForegroundColor Yellow
try {
    python -c "import whisper"
    Write-Host "   ✓ Whisper installed successfully" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Whisper installation failed" -ForegroundColor Red
    deactivate
    exit 1
}

# Create activation helper script
Write-Host ""
Write-Host "9. Creating helper scripts..." -ForegroundColor Yellow
$activateScript = @"
# Helper script to activate the virtual environment
.\venv\Scripts\Activate.ps1
Write-Host "Virtual environment activated!" -ForegroundColor Green
Write-Host "Run: python transcribe_video.py" -ForegroundColor Cyan
"@
$activateScript | Out-File -FilePath "activate_env.ps1" -Encoding UTF8
Write-Host "   ✓ Created activate_env.ps1 helper script" -ForegroundColor Green

deactivate

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To use the transcription script:" -ForegroundColor Cyan
Write-Host "   1. Activate virtual environment: .\venv\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   2. Run transcription: python transcribe_video.py" -ForegroundColor White
Write-Host "   3. Deactivate when done: deactivate" -ForegroundColor White
Write-Host ""
Write-Host "Or simply run: .\activate_env.ps1" -ForegroundColor Yellow
Write-Host ""
