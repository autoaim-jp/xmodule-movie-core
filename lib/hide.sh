#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
##DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}asset/src/project/sample/
##CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output 
OUTPUT_FILE_PATH=${1:-"${SAMPLE_PROJECT_DIR_PATH}hide_result.mp4"}

# input
INPUT_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}concat_movie.mp4"}

# url
ffmpeg -i $INPUT_FILE_PATH -vf "drawbox=x=100:y=70:w=200:h=50:color=#004896:t=fill" -c:a copy -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $OUTPUT_FILE_PATH

# alertのurl
# ffmpeg -i $INPUT_FILE_PATH -vf "drawbox=x=750:y=110:w=150:h=50:color=#fefefe:t=fill" -c:a copy -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $OUTPUT_FILE_PATH

