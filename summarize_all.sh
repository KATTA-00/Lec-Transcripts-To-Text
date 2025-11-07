#!/bin/bash
# Summarize All Transcripts using Sumy (Extractive Summarization)
# Creates concise summaries of lecture transcripts

echo "========================================"
echo "Transcript Summarization Script"
echo "========================================"
echo ""

TRANSCRIPTS_DIR="transcripts"
SUMMARIES_DIR="summaries"
SENTENCES_COUNT=30

# Check if transcripts directory exists
if [ ! -d "$TRANSCRIPTS_DIR" ]; then
    echo "Error: $TRANSCRIPTS_DIR directory not found!"
    echo "Please run ./transcribe_all.sh first to generate transcripts."
    exit 1
fi

# Count transcript files
transcript_count=$(find "$TRANSCRIPTS_DIR" -name "*_transcript.txt" 2>/dev/null | wc -l)

if [ $transcript_count -eq 0 ]; then
    echo "Error: No transcript files found in $TRANSCRIPTS_DIR/"
    echo "Please run ./transcribe_all.sh first."
    exit 1
fi

echo "Found $transcript_count transcript(s) to summarize"
echo "Generating summaries with $SENTENCES_COUNT sentences each"
echo ""

# Create summaries directory
mkdir -p "$SUMMARIES_DIR"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run ./install.sh first."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if sumy is installed
echo ""
echo "Checking for Sumy package..."
if ! python -c "import sumy" 2>/dev/null; then
    echo "Installing Sumy..."
    pip install sumy nltk
    python -c "import nltk; nltk.download('punkt')"
    echo "✓ Sumy installed"
else
    echo "✓ Sumy already installed"
fi

echo ""
echo "=========================================="
echo "Summarizing Transcripts"
echo "=========================================="
echo ""

# Summarize each transcript
summarized=0
failed=0
current=0

for transcript_file in "$TRANSCRIPTS_DIR"/*/"*_transcript.txt"; do
    if [ -f "$transcript_file" ]; then
        ((current++))
        
        # Get video name from path
        video_dir=$(dirname "$transcript_file")
        video_name=$(basename "$video_dir")
        
        # Output summary file
        summary_file="$SUMMARIES_DIR/${video_name}_summary.txt"
        
        echo "[$current/$transcript_count] Summarizing: $video_name"
        
        # Run Python summarizer
        python summarize_transcript.py "$transcript_file" "$summary_file" "$SENTENCES_COUNT"
        
        if [ $? -eq 0 ]; then
            ((summarized++))
            echo "✓ Summary saved: $summary_file"
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
echo "Summarization Complete"
echo "=========================================="
echo "Total transcripts: $transcript_count"
echo "Successfully summarized: $summarized"
echo "Failed: $failed"
echo ""
echo "Summaries saved in: ./$SUMMARIES_DIR/"
echo ""

if [ $failed -eq 0 ]; then
    echo "✅ All transcripts summarized successfully!"
else
    echo "⚠️  $failed transcript(s) failed. Check the logs above."
fi
