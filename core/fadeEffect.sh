#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
TITLE_MOVIE_FILE_PATH=${1:-/tmp/title.mp4}

# input
TITLE_IMG_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}title.png"}
TITLE_SEC=${3:-5}  # デフォルトは5秒

# tmp
TMP_FADEIN_FILE_PATH="${TMP_DIR_PATH}__fadein.mp4"

# other

ffmpeg -y -loop 1 -framerate 60 -i $TITLE_IMG_FILE_PATH -vf "fade=in:0:30,format=yuv420p" -t ${TITLE_SEC} -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $TMP_FADEIN_FILE_PATH
     
ffmpeg -y -i $TMP_FADEIN_FILE_PATH -vf "fade=out:120:30,format=yuv420p" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $TITLE_MOVIE_FILE_PATH

