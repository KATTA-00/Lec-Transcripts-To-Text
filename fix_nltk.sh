#!/bin/bash
# Quick fix to download NLTK data

echo "Downloading NLTK data for summarization..."

source venv/bin/activate

python -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab')"

deactivate

echo "✓ NLTK data downloaded successfully!"
echo "You can now run: ./summarize_all.sh"
