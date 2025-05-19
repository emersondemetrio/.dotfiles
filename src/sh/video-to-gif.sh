#!/bin/bash

# acrh -arm64 brew install ffmpeg
# brew install ffmpeg

# usage: ./video-to-gif.sh input.mp4 output.gif [resolution]

clear
abs_path() {
    echo "$(
        cd $(dirname "$1")
        pwd
    )/$(basename "$1")"
}

FILE_NAME=$1
INPUT_PATH=$(abs_path $1)
OUTPUT_PATH=$(abs_path $2)
RESOLUTION=$3

OUTPUT_PATH=$2
if [ -z "$OUTPUT_PATH" ]; then
    OUTPUT_PATH="${FILE_NAME%%.*}.gif"
fi

if [ -n "$RESOLUTION" ]; then
    echo "Custom resolution: $RESOLUTION"
else
    RESOLUTION=120
    echo "Default resolution: $RESOLUTION"
fi

ffmpeg -y \
    -ss 0 -t 300 \
    -i $INPUT_PATH \
    -vf "fps=10,scale=$RESOLUTION:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 \
    $OUTPUT_PATH
clear
echo
echo
ls -las | grep "gif"
echo "Done!"
