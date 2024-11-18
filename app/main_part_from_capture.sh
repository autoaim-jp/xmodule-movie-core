#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  OUTPUT_MOVIE_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/main_part_from_capture/
  mkdir -p $OUTPUT_DIR_PATH
  OUTPUT_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4
fi

# input
CAPTURE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}capture.mp4"}
RT_OWNER_IMAGE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}asset/right_top_owner.png"}
LT_THEME_IMAGE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}asset/left_top_theme.png"}
RB_TOPIC_IMAGE_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}asset/right_bottom_topic.png"}
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${SAMPLE_PROJECT_DIR_PATH}asset/woman_flop.png"}

# キャプチャ動画にテロップを追加
${ROOT_DIR_PATH}core/addTelopIntoCapture.sh $OUTPUT_MOVIE_FILE_PATH $CAPTURE_MOVIE_FILE_PATH $RT_OWNER_IMAGE_FILE_PATH $LT_THEME_IMAGE_FILE_PATH $RB_TOPIC_IMAGE_FILE_PATH $LB_NARRATOR_IMAGE_FILE_PATH
echo "作成したメイン動画: ${OUTPUT_MOVIE_FILE_PATH}"

