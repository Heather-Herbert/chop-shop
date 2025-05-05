import json
import os
import subprocess
from collections import defaultdict
import sys

if len(sys.argv) < 3:
    print("Usage: extract_words.py <video.mp4> <transcript.json>")
    sys.exit(1)

video = sys.argv[1]
json_file = sys.argv[2]

with open(json_file, "r") as f:
    data = json.load(f)

word_count = defaultdict(int)

for segment in data["segments"]:
    for word in segment["words"]:
        start = word["start"]
        end = word["end"]
        raw_text = word["word"].strip().lower()

        clean = "".join(c for c in raw_text if c.isalnum() or c == '_')
        if not clean:
            continue

        filename = f"{clean}.mp4"
        if os.path.exists(filename):
            word_count[clean] += 1
            filename = f"{clean}_{word_count[clean]}.mp4"

        temp_file = f"__{filename}"

        subprocess.run([
            "ffmpeg", "-y", "-i", video,
            "-ss", f"{start:.3f}", "-to", f"{end:.3f}",
            "-c", "copy", temp_file
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        subprocess.run([
            "ffmpeg", "-y", "-i", temp_file,
            "-af", "silenceremove=start_periods=1:start_duration=0.05:start_threshold=-40dB:"
                   "stop_periods=1:stop_duration=0.1:stop_threshold=-40dB",
            "-c:v", "copy", filename
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        os.remove(temp_file)

print("✅ Word clips generated and silence trimmed.")
