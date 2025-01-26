#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
CONCAT_MOVIE_FILE_PATH=${1:-/tmp/concat.mp4}

# input
TITLE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}title_movie.mp4"}
MAIN_PART_MOVIE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}main_part.mp4"}
LOGO_ROTATE_MOVIE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}0520.mp4"}

# tmp
REENCODED_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_reencoded.mp4"
REENCODED_MAIN_PART_MOVIE_FILE_PATH="${TMP_DIR_PATH}__main_part_reencoded.mp4"
REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__logo_rotate_reencoded.mp4"

# 同じ条件でエンコードし直す
ffmpeg -y -i $TITLE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $REENCODED_TITLE_MOVIE_FILE_PATH

ffmpeg -y -i $MAIN_PART_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $REENCODED_MAIN_PART_MOVIE_FILE_PATH
ffmpeg -y -i $LOGO_ROTATE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH

# タイトル動画、ロゴ回転動画、メインパート動画を結合する
ffmpeg -y -i $REENCODED_TITLE_MOVIE_FILE_PATH -i $REENCODED_MAIN_PART_MOVIE_FILE_PATH -i $REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH -filter_complex "[0:v:0][1:v:0][2:v:0]concat=n=3:v=1:a=0[v]" -map "[v]" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $CONCAT_MOVIE_FILE_PATH
