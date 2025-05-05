# chop-shop
Split an mp4 file into each word said (useful for recombining into a song)


How to Use Everything

    Create the virtual environment

python3 -m venv whisperenv
source whisperenv/bin/activate
pip install git+https://github.com/openai/whisper.git torch

Run the script

chmod +x split_by_word.sh
./split_by_word.sh yourvideo.mp4

(Optional) Deactivate the virtual environment when done:

    deactivate

Would you like to turn this into a .deb or makefile-based tool for repeated use?
