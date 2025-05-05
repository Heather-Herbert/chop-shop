#!/bin/bash

# Usage: ./add_subtitles.sh input.mp4 output.mp4
# Whisper will generate subtitles.srt automatically.

INPUT="$1"
OUTPUT="$2"
BASENAME="${INPUT%.*}"
SUBS="${BASENAME}.srt"

if [[ -z "$INPUT" || -z "$OUTPUT" ]]; then
    echo "Usage: $0 input.mp4 output.mp4"
    exit 1
fi

echo "🧠 Step 1: Transcribing $INPUT with Whisper..."
whisper "$INPUT" --model medium --language en --output_format srt

if [ ! -f "$SUBS" ]; then
    echo "❌ Subtitles not generated. Aborting."
    exit 1
fi

echo "🎞️ Step 2: Burning subtitles into video..."

ffmpeg -i "$INPUT" -vf \
"subtitles='$SUBS':force_style='FontName=Arial,FontSize=24,PrimaryColour=&H00FFFFFF,BackColour=&H000000FF,\
BorderStyle=3,Outline=1,Shadow=0,Alignment=2'" \
-c:a copy "$OUTPUT"

echo "✅ Done! Subtitled video saved to: $OUTPUT"
