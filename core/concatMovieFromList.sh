#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
OUTPUT_MOVIE_FILE_PATH=${1:-/tmp/output.mp4}

# input
MOVIE_PART_LIST_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}main_part/part_list.txt"}

# 結合ファイル一覧から結合動画作成
ffmpeg -y -f concat -safe 0 -i $MOVIE_PART_LIST_FILE_PATH -c:a copy -c:v h264_nvenc $OUTPUT_MOVIE_FILE_PATH < /dev/null

