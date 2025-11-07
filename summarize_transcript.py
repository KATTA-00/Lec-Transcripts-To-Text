"""
Transcript Summarization Script using Sumy
Generates extractive summaries from lecture transcripts
Uses LexRank algorithm for best sentence selection
"""

import sys
import os
from sumy.parsers.plaintext import PlaintextParser
from sumy.nlp.tokenizers import Tokenizer
from sumy.summarizers.lex_rank import LexRankSummarizer
from sumy.summarizers.lsa import LsaSummarizer
from sumy.summarizers.luhn import LuhnSummarizer


def summarize_transcript(input_file, output_file, sentence_count=30, method="lexrank"):
    """
    Summarize a transcript file using extractive summarization
    
    Args:
        input_file: Path to the transcript text file
        output_file: Path to save the summary
        sentence_count: Number of sentences to extract (default: 30)
        method: Summarization method (lexrank, lsa, luhn)
    """
    
    try:
        # Check if input file exists
        if not os.path.exists(input_file):
            print(f"Error: Input file not found: {input_file}")
            return False
        
        # Read the transcript
        print(f"Reading transcript from: {input_file}")
        
        # Parse the document
        parser = PlaintextParser.from_file(input_file, Tokenizer("english"))
        
        # Choose summarizer
        if method == "lexrank":
            summarizer = LexRankSummarizer()
            print("Using LexRank algorithm (best for coherent summaries)")
        elif method == "lsa":
            summarizer = LsaSummarizer()
            print("Using LSA algorithm")
        elif method == "luhn":
            summarizer = LuhnSummarizer()
            print("Using Luhn algorithm")
        else:
            summarizer = LexRankSummarizer()
            print("Using default LexRank algorithm")
        
        # Generate summary
        print(f"Generating summary with {sentence_count} sentences...")
        summary = summarizer(parser.document, sentence_count)
        
        # Write summary to file
        with open(output_file, "w", encoding="utf-8") as f:
            # Add header
            f.write("=" * 80 + "\n")
            f.write(f"SUMMARY - {sentence_count} Key Sentences (Extractive)\n")
            f.write("=" * 80 + "\n\n")
            
            # Write sentences
            for i, sentence in enumerate(summary, start=1):
                f.write(f"{i}. {sentence}\n\n")
            
            # Add footer
            f.write("\n" + "=" * 80 + "\n")
            f.write(f"Generated using Sumy ({method.upper()}) - Extractive Summarization\n")
            f.write("All sentences are directly from the original transcript\n")
            f.write("=" * 80 + "\n")
        
        print(f"✓ Summary successfully saved to: {output_file}")
        
        # Show preview
        print("\nPreview (first 3 sentences):")
        print("-" * 60)
        for i, sentence in enumerate(list(summary)[:3], start=1):
            print(f"{i}. {sentence}")
        print("-" * 60)
        
        return True
        
    except Exception as e:
        print(f"❌ Error during summarization: {str(e)}")
        return False


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python summarize_transcript.py <input_file> <output_file> [sentence_count] [method]")
        print("\nMethods: lexrank (default), lsa, luhn")
        print("Example: python summarize_transcript.py transcript.txt summary.txt 30 lexrank")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    sentence_count = int(sys.argv[3]) if len(sys.argv) > 3 else 30
    method = sys.argv[4] if len(sys.argv) > 4 else "lexrank"
    
    success = summarize_transcript(input_file, output_file, sentence_count, method)
    sys.exit(0 if success else 1)
