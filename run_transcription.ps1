# Quick Run Script for Video Transcription
# This script runs the transcription with default settings using the virtual environment

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Video Transcription" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment exists
if (-Not (Test-Path "venv")) {
    Write-Host "Error: Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run .\install.ps1 first to set up the environment." -ForegroundColor Yellow
    exit 1
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

# Check if transcribe_video.py exists
if (-Not (Test-Path "transcribe_video.py")) {
    Write-Host "Error: transcribe_video.py not found!" -ForegroundColor Red
    deactivate
    exit 1
}

# Check if video file exists
if (-Not (Test-Path "Lecture 1 - Computer Abstractions.mp4")) {
    Write-Host "Error: Video file 'Lecture 1 - Computer Abstractions.mp4' not found!" -ForegroundColor Red
    deactivate
    exit 1
}

# Run the transcription
Write-Host "Running transcription script..." -ForegroundColor Yellow
Write-Host "This may take several minutes depending on video length..." -ForegroundColor Cyan
Write-Host ""

python transcribe_video.py

$exitCode = $LASTEXITCODE

# Deactivate virtual environment
deactivate

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ Transcription Completed Successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "✗ Transcription Failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    exit 1
}
