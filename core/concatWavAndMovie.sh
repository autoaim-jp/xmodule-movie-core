#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
FINAL_MOVIE_FILE_PATH=${1:-/tmp/final.mp4}

# input
CONCAT_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}concat_movie.mp4"}
CONCAT_SOUND_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}concat_sound.wav"}

# 動画ファイルと音声ファイルを結合する
ffmpeg -i $CONCAT_MOVIE_FILE_PATH -i $CONCAT_SOUND_FILE_PATH -c:v copy -c:a aac -strict experimental $FINAL_MOVIE_FILE_PATH

