#!/bin/bash

# Usage: ./generate_falling_subtitles.sh input.mp4 output.mp4

VIDEO="$1"
OUTPUT="$2"
BASENAME="${VIDEO%.*}"
SUBASS="${BASENAME}_falling.ass"

if [[ -z "$VIDEO" || -z "$OUTPUT" ]]; then
    echo "Usage: $0 input.mp4 output.mp4"
    exit 1
fi

echo "🔍 Step 1: Transcribing with Whisper..."
whisper "$VIDEO" --model medium --language en --output_format json

echo "🪄 Step 2: Generating animated ASS subtitles..."

python3 - <<EOF
import json
import os

basename = "$BASENAME"
json_file = basename + ".json"
output_file = "$SUBASS"

with open(json_file, "r") as f:
    data = json.load(f)

header = """
[Script Info]
ScriptType: v4.00+
Collisions: Normal
PlayResX: 1920
PlayResY: 1080
Timer: 100.0000

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, 
        StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default, Arial, 48, &H00FFFFFF, &H000000FF, &H00000000, &H000000FF, -1, 0, 0, 0, 100, 100, 0, 0, 3, 2, 0, 2, 10, 10, 30, 1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
"""

with open(output_file, "w") as f:
    f.write(header.strip() + "\n")

    for segment in data["segments"]:
        start = segment["start"]
        end = segment["end"]
        text = segment["text"].replace("\n", " ").strip()

        def fmt_time(seconds):
            h = int(seconds // 3600)
            m = int((seconds % 3600) // 60)
            s = int(seconds % 60)
            cs = int((seconds - int(seconds)) * 100)
            return f"{h:01d}:{m:02d}:{s:02d}.{cs:02d}"

        # ASS \move + \fad effect (fall in, fade out)
        effect = r"{\move(960,0,960,960)\fad(250,250)}"  # move Y from top to center

        line = f"Dialogue: 0,{fmt_time(start)},{fmt_time(end)},Default,,0,0,0,,{effect}{text}\n"
        f.write(line)

print(f"✅ ASS subtitles with falling effect written to {output_file}")
EOF

echo "🎞️ Step 3: Rendering subtitles onto video..."

export FONTCONFIG_PATH="$(pwd)/typefaces"

ffmpeg -y -i "$VIDEO" -vf "ass=$SUBASS" -c:a copy "$OUTPUT"

echo "✅ All done! Output written to: $OUTPUT"
