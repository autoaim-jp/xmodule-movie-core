#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  OUTPUT_MOVIE_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/main_part_from_image_list/
  mkdir -p $OUTPUT_DIR_PATH
  OUTPUT_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4
fi

# input
# CENTER_IMAGE_LIST_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number.txt"}
CENTER_IMAGE_LIST_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number_only3.txt"}
BACKGROUND_IMAGE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}asset/background.jpg"}
RT_OWNER_IMAGE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}asset/right_top_owner.png"}
LT_THEME_IMAGE_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}asset/left_top_theme.png"}
RB_TOPIC_IMAGE_FILE_PATH=${6:-"${SAMPLE_PROJECT_DIR_PATH}asset/right_bottom_topic.png"}
LB_NARRATOR_IMAGE_FILE_PATH=${7:-"${SAMPLE_PROJECT_DIR_PATH}asset/woman_flop.png"}

# tmp
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/
mkdir -p $TMP_DIR_PATH
BASE_PART_MOVIE_FILE_PATH=${TMP_DIR_PATH}base.mp4
MOVIE_PART_DIR_PATH=${TMP_DIR_PATH}${CURRENT_TIME}/
mkdir -p $MOVIE_PART_DIR_PATH
MOVIE_PART_LIST_FILE_PATH=${TMP_DIR_PATH}part_list.txt

# ベース動画作成
${ROOT_DIR_PATH}core/createBasePartMovie.sh $BASE_PART_MOVIE_FILE_PATH $CENTER_IMAGE_LIST_FILE_PATH $BACKGROUND_IMAGE_FILE_PATH $RT_OWNER_IMAGE_FILE_PATH $LT_THEME_IMAGE_FILE_PATH $RB_TOPIC_IMAGE_FILE_PATH $LB_NARRATOR_IMAGE_FILE_PATH
echo "作成したベース動画: ${BASE_PART_MOVIE_FILE_PATH}"

# フェード動画を作成し、ベース動画と結合
${ROOT_DIR_PATH}core/mergeBaseAndFadeMovie.sh $MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $CENTER_IMAGE_LIST_FILE_PATH $BASE_PART_MOVIE_FILE_PATH
echo "パート動画リスト: ${MOVIE_PART_LIST_FILE_PATH}"
echo "パート動画ディレクトリ: ${MOVIE_PART_DIR_PATH}"

# パートファイル一覧から結合動画を作成
${ROOT_DIR_PATH}core/concatMovieFromList.sh $OUTPUT_MOVIE_FILE_PATH $MOVIE_PART_LIST_FILE_PATH
echo "作成したメインパート動画: ${OUTPUT_MOVIE_FILE_PATH}"


