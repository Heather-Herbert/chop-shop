# Chop Shop

This project provides a set of scripts to manipulate video files based on spoken words within them. The primary function is to split a video file into individual clips, each containing a single spoken word[cite: 1]. This can be useful for creative projects like rearranging speech into songs. Additional scripts are provided for adding standard or animated subtitles and trimming silence from video clips.

## Features

* Transcribes videos using OpenAI's Whisper.
* Splits videos into individual word clips based on Whisper's timestamps.
* Trims silence from the beginning and end of generated word clips.
* Adds standard hardcoded subtitles to videos.
* Adds animated "falling" subtitles to videos.
* Trims silence from arbitrary video clips.

## Setup

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <your-repository-url>
    cd chop-shop
    ```

2.  **Create and activate a Python virtual environment:**
    ```bash
    python3 -m venv whisperenv
    source whisperenv/bin/activate
    ```
    * *(Note: On Windows PowerShell, use `whisperenv\Scripts\Activate.ps1`)*
    * *(Note: On csh/tcsh, use `source whisperenv/bin/activate.csh`)*

3.  **Install dependencies:**
    ```bash
    pip install git+[https://github.com/openai/whisper.git](https://github.com/openai/whisper.git) torch
    ```

4.  **Ensure `ffmpeg` is installed:** These scripts rely heavily on `ffmpeg`. If you don't have it, install it using your system's package manager (e.g., `sudo apt update && sudo apt install ffmpeg` on Debian/Ubuntu, `brew install ffmpeg` on macOS).

5.  **Make scripts executable:**
    ```bash
    chmod +x *.sh
    ```

## Scripts

Here's a breakdown of the included scripts:

### `split_by_word.sh`

* **Purpose:** This is the main script to split a video into individual word clips.
* **What it does:**
    1.  Activates the `whisperenv` virtual environment.
    2.  Runs Whisper to transcribe the input video, generating a JSON file with word timestamps.
    3.  Calls `extract_words.py` to create the individual word clips.
* **How to call:**
    ```bash
    ./split_by_word.sh yourvideo.mp4
    ```
    This will generate numerous `word.mp4`, `word_1.mp4`, etc., files in the current directory.

### `extract_words.py`

* **Purpose:** Extracts word clips from a video based on a Whisper JSON transcript. (Usually called by `split_by_word.sh`).
* **What it does:**
    1.  Reads word timestamp data from the JSON file.
    2.  Uses `ffmpeg` to cut the original video into small clips for each word.
    3.  Uses `ffmpeg` with the `silenceremove` filter to trim leading/trailing silence from each word clip.
* **How to call (standalone):**
    ```bash
    python extract_words.py <path/to/video.mp4> <path/to/transcript.json>
    ```

### `add_subtitles.sh`

* **Purpose:** Adds standard, hardcoded subtitles to a video.
* **What it does:**
    1.  Uses Whisper to generate an SRT subtitle file (`.srt`) for the input video.
    2.  Uses `ffmpeg` to "burn" the subtitles onto the video track.
* **How to call:**
    ```bash
    ./add_subtitles.sh input.mp4 output_subtitled.mp4
    ```

### `generate_falling_subtitles.sh`

* **Purpose:** Generates animated "falling" subtitles and adds them to a video.
* **What it does:**
    1.  Uses Whisper to generate a JSON transcript.
    2.  Runs an embedded Python script to convert the JSON transcript into an Advanced SubStation Alpha (`.ass`) subtitle file with falling text animation directives.
    3.  Uses `ffmpeg` to render the ASS subtitles onto the video.
* **How to call:**
    ```bash
    ./generate_falling_subtitles.sh input.mp4 output_falling_subs.mp4
    ```

### `trim_silence.sh`

* **Purpose:** Removes leading and trailing silence from a video clip.
* **What it does:**
    1.  Uses `ffmpeg` and the `silenceremove` audio filter to detect and remove silence from the start and end of the input file.
* **How to call:**
    ```bash
    ./trim_silence.sh input_clip.mp4 output_trimmed_clip.mp4
    ```

## Deactivating the Environment

When you're finished using the scripts, you can deactivate the virtual environment:
```bash
deactivate
