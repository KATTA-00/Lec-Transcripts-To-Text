"""
Batch Transcription Helper Script
Used by the batch processing shell script to transcribe individual videos
"""

import whisper
import sys
import os

def transcribe_single_video(video_path, output_dir, model_size="medium"):
    """
    Transcribe a single video and save outputs to specified directory
    
    Args:
        video_path: Path to the video file
        output_dir: Directory to save transcripts
        model_size: Whisper model size (tiny, base, small, medium, large)
    """
    
    video_name = os.path.splitext(os.path.basename(video_path))[0]
    
    try:
        print(f"Loading Whisper model: {model_size}")
        model = whisper.load_model(model_size)
        
        print(f"Transcribing: {video_name}")
        print("This may take several minutes...")
        
        # Transcribe the video
        result = model.transcribe(video_path)
        
        # Save as plain text
        txt_file = os.path.join(output_dir, f"{video_name}.txt")
        with open(txt_file, "w", encoding="utf-8") as f:
            f.write(result["text"])
        print(f"✓ Text saved: {txt_file}")
        
        # Save as VTT
        vtt_file = os.path.join(output_dir, f"{video_name}.vtt")
        with open(vtt_file, "w", encoding="utf-8") as f:
            whisper.utils.write_vtt(result["segments"], file=f)
        print(f"✓ VTT saved: {vtt_file}")
        
        # Save as SRT
        srt_file = os.path.join(output_dir, f"{video_name}.srt")
        with open(srt_file, "w", encoding="utf-8") as f:
            whisper.utils.write_srt(result["segments"], file=f)
        print(f"✓ SRT saved: {srt_file}")
        
        # Save as JSON
        import json
        json_file = os.path.join(output_dir, f"{video_name}.json")
        with open(json_file, "w", encoding="utf-8") as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
        print(f"✓ JSON saved: {json_file}")
        
        print(f"\n✅ Transcription complete for: {video_name}")
        return True
        
    except Exception as e:
        print(f"\n❌ Error transcribing {video_name}: {str(e)}")
        return False


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python batch_transcribe.py <video_path> <output_dir> <model_size>")
        sys.exit(1)
    
    video_path = sys.argv[1]
    output_dir = sys.argv[2]
    model_size = sys.argv[3]
    
    success = transcribe_single_video(video_path, output_dir, model_size)
    sys.exit(0 if success else 1)
