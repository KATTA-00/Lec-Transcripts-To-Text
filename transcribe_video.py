"""
Video Transcription Script using OpenAI Whisper
Transcribes video files to text using the Whisper model
"""

import whisper
import os
import sys


def format_timestamp(seconds):
    """Format seconds to timestamp string"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d}.{millis:03d}"


def write_vtt(segments, file):
    """Write segments to VTT format"""
    print("WEBVTT\n", file=file)
    for segment in segments:
        start = format_timestamp(segment['start'])
        end = format_timestamp(segment['end'])
        text = segment['text'].strip()
        print(f"{start} --> {end}\n{text}\n", file=file)


def write_srt(segments, file):
    """Write segments to SRT format"""
    for i, segment in enumerate(segments, start=1):
        start = format_timestamp(segment['start']).replace('.', ',')
        end = format_timestamp(segment['end']).replace('.', ',')
        text = segment['text'].strip()
        print(f"{i}\n{start} --> {end}\n{text}\n", file=file)

def transcribe_video(video_path, model_size="medium", output_format="txt"):
    """
    Transcribe a video file using Whisper
    
    Args:
        video_path: Path to the video file
        model_size: Whisper model size (tiny, base, small, medium, large)
        output_format: Output format (txt, vtt, srt, json, all)
    """
    
    # Check if video file exists
    if not os.path.exists(video_path):
        print(f"Error: Video file '{video_path}' not found!")
        return False
    
    print(f"Loading Whisper model: {model_size}")
    print("This may take a moment on first run...")
    
    try:
        # Load the Whisper model
        model = whisper.load_model(model_size)
        
        print(f"\nTranscribing: {video_path}")
        print("This may take several minutes depending on video length...")
        
        # Transcribe the video
        result = model.transcribe(video_path)
        
        # Get the base filename without extension
        base_name = os.path.splitext(video_path)[0]
        
        # Save transcript as text file
        if output_format in ["txt", "all"]:
            txt_file = f"{base_name}_transcript.txt"
            with open(txt_file, "w", encoding="utf-8") as f:
                f.write(result["text"])
            print(f"\n✓ Text transcript saved: {txt_file}")
        
        # Save as VTT (Web Video Text Tracks)
        if output_format in ["vtt", "all"]:
            vtt_file = f"{base_name}_transcript.vtt"
            with open(vtt_file, "w", encoding="utf-8") as f:
                write_vtt(result["segments"], f)
            print(f"✓ VTT file saved: {vtt_file}")
        
        # Save as SRT (SubRip)
        if output_format in ["srt", "all"]:
            srt_file = f"{base_name}_transcript.srt"
            with open(srt_file, "w", encoding="utf-8") as f:
                write_srt(result["segments"], f)
            print(f"✓ SRT file saved: {srt_file}")
        
        # Save full JSON output
        if output_format in ["json", "all"]:
            import json
            json_file = f"{base_name}_transcript.json"
            with open(json_file, "w", encoding="utf-8") as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f"✓ JSON file saved: {json_file}")
        
        print(f"\n✅ Transcription complete!")
        print(f"\nPreview of transcript:")
        print("-" * 50)
        print(result["text"][:500] + "..." if len(result["text"]) > 500 else result["text"])
        print("-" * 50)
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error during transcription: {str(e)}")
        return False


if __name__ == "__main__":
    # Configuration
    VIDEO_FILE = "Lecture 1 - Computer Abstractions.mp4"
    MODEL_SIZE = "large"  # Options: tiny, base, small, medium, large
    OUTPUT_FORMAT = "all"  # Options: txt, vtt, srt, json, all
    
    print("=" * 60)
    print("Video Transcription Script - OpenAI Whisper")
    print("=" * 60)
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    video_path = os.path.join(script_dir, VIDEO_FILE)
    
    # Run transcription
    success = transcribe_video(video_path, MODEL_SIZE, OUTPUT_FORMAT)
    
    if success:
        print("\n🎉 All done! Check the output files in the same directory.")
    else:
        print("\n⚠️ Transcription failed. Please check the error messages above.")
        sys.exit(1)
