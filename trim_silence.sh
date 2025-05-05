#!/bin/bash

# Usage: ./trim_silence.sh input.mp4 output.mp4

INPUT="$1"
OUTPUT="$2"

if [[ -z "$INPUT" || -z "$OUTPUT" ]]; then
    echo "Usage: $0 input.mp4 output.mp4"
    exit 1
fi

ffmpeg -i "$INPUT" \
  -af "silenceremove=start_periods=1:start_duration=0.025:start_threshold=-40dB:\
stop_periods=1:stop_duration=0.025:stop_threshold=-40dB" \
  -c:v copy "$OUTPUT"
