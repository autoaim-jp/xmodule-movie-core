#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
CONCAT_MOVIE_FILE_PATH=${1:-/tmp/concat.mp4}

# input
TITLE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}title_movie.mp4"}
MAIN_PART_MOVIE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}main_part.mp4"}

ending_file_list=(
  "0520.mp4"
  "0520_reverse.mp4"
  "0729.mp4"
  "0729_reverse.mp4"
  "0730.mp4"
  "0730_reverse.mp4"
)

# ランダムに1つ選択
random_index=$((RANDOM % ${#ending_file_list[@]}))
LOGO_ROTATE_MOVIE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}${ending_file_list[random_index]}"}

# tmp
REENCODED_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_reencoded.mp4"
REENCODED_MAIN_PART_MOVIE_FILE_PATH="${TMP_DIR_PATH}__main_part_reencoded.mp4"
REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__logo_rotate_reencoded.mp4"

# 同じ条件でエンコードし直す
ffmpeg -y -i $TITLE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_TITLE_MOVIE_FILE_PATH
ffmpeg -y -i $MAIN_PART_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_MAIN_PART_MOVIE_FILE_PATH
ffmpeg -y -i $LOGO_ROTATE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH

# タイトル動画、ロゴ回転動画、メインパート動画を結合する
ffmpeg -y -i $REENCODED_TITLE_MOVIE_FILE_PATH -i $REENCODED_MAIN_PART_MOVIE_FILE_PATH -i $REENCODED_LOGO_ROTATE_MOVIE_FILE_PATH -filter_complex "[0:v:0][1:v:0][2:v:0]concat=n=3:v=1:a=0[v]" -map "[v]" $CONCAT_MOVIE_FILE_PATH
