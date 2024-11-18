#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
CONCAT_MOVIE_FILE_PATH=${1:-/tmp/concat.mp4}

# input
TITLE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}title_movie.mp4"}
CAPTURE_MOVIE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}capture.mp4"}

# tmp
REENCODED_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_reencoded.mp4"
REENCODED_CAPTURE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__capture_reencoded.mp4"

# 同じ条件でエンコードし直す
ffmpeg -y -i $TITLE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_TITLE_MOVIE_FILE_PATH
ffmpeg -y -i $CAPTURE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_CAPTURE_MOVIE_FILE_PATH

# タイトル動画とキャプチャ動画を結合する
ffmpeg -y -i $REENCODED_TITLE_MOVIE_FILE_PATH -i $REENCODED_CAPTURE_MOVIE_FILE_PATH -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[v]" -map "[v]" $CONCAT_MOVIE_FILE_PATH

