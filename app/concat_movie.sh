#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  FINAL_MOVIE_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/concat_movie/ 
  mkdir -p $OUTPUT_DIR_PATH
  FINAL_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4
fi

# input
TITLE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}title_movie.mp4"}
MAIN_PART_MOVIE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}main_part.mp4"}
CONCAT_SOUND_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}concat_sound.wav"}
ENDING_FILE_INDEX=${5:--1}

# tmp
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/concat_movie/ 
mkdir -p $TMP_DIR_PATH
CONCAT_MOVIE_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}.mp4

ending_file_list=(
  "0520.mp4"
  "0520_reverse.mp4"
  "0729.mp4"
  "0729_reverse.mp4"
  "0730.mp4"
  "0730_reverse.mp4"
)

# ランダムに1つ選択
if [[ $ENDING_FILE_INDEX -ge 0 && $ENDING_FILE_INDEX -lt ${#ending_file_list[@]} ]]; then
  random_index=$ENDING_FILE_INDEX
else
  random_index=$((RANDOM % ${#ending_file_list[@]}))
fi
LOGO_ROTATE_MOVIE_FILE_PATH="${SAMPLE_PROJECT_DIR_PATH}${ending_file_list[$random_index]}"

${ROOT_DIR_PATH}core/concatMovie.sh $CONCAT_MOVIE_FILE_PATH $TITLE_MOVIE_FILE_PATH $MAIN_PART_MOVIE_FILE_PATH $LOGO_ROTATE_MOVIE_FILE_PATH
echo "タイトルとキャプチャの結合動画: $CONCAT_MOVIE_FILE_PATH"

${ROOT_DIR_PATH}core/concatWavAndMovie.sh $FINAL_MOVIE_FILE_PATH $CONCAT_SOUND_FILE_PATH $CONCAT_MOVIE_FILE_PATH
echo "動画と音声の結合結果: $FINAL_MOVIE_FILE_PATH"

