#!/bin/bash

VIDEO="$1"
BASENAME="${VIDEO%.*}"
MODEL="medium"

if [[ -z "$VIDEO" ]]; then
    echo "Usage: $0 yourvideo.mp4"
    exit 1
fi

echo "[1/3] Activating virtual environment..."
source whisperenv/bin/activate || { echo "Virtualenv not found!"; exit 1; }

echo "[2/3] Running Whisper transcription..."
whisper "$VIDEO" --model "$MODEL" --language en --word_timestamps True --output_format json

echo "[3/3] Running word-splitting script..."
python extract_words.py "$VIDEO" "${BASENAME}.json"
