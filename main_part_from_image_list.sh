#!/bin/bash

DATA_DIR_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  OUTPUT_MOVIE_FILE_PATH=${1}
else
  OUTPUT_MOVIE_FILE_PATH=${DATA_DIR_PATH}generated/main_part_from_image_list/${CURRENT_TIME}.mp4
fi

# input
RIGHT_TOP_TEXT=${2:-"動画さん"}
LEFT_TOP_TEXT=${3:-"研修カリキュラム自動作成"}
RIGHT_BOTTOM_TEXT=${4:-"このアプリの使い方"}
FONT_FILE_PATH=${5:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${DATA_DIR_PATH}src/project/sample/asset/woman_flop.png"}
BACKGROUND_IMAGE_FILE_PATH=${7:-"${DATA_DIR_PATH}src/project/sample/asset/background.jpg"}
# CENTER_IMAGE_LIST_FILE_PATH=${8:-"${DATA_DIR_PATH}src/project/sample/image_list_number.txt"}
CENTER_IMAGE_LIST_FILE_PATH=${8:-"${DATA_DIR_PATH}src/project/sample/image_list_number_only3.txt"}

# other
RT_OWNER_IMAGE_FILE_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/right_top_owner.png
LT_THEME_IMAGE_FILE_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/left_top_theme.png
RB_TOPIC_IMAGE_FILE_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/right_bottom_topic.png
BASE_PART_MOVIE_FILE_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/base.mp4
MOVIE_PART_DIR_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/${CURRENT_TIME}/
MOVIE_PART_LIST_FILE_PATH=${DATA_DIR_PATH}tmp/main_part_from_image_list/part_list.txt

# 右上の動画オーナー画像作成
./core/createOwnerImageRT.sh $RT_OWNER_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_TOP_TEXT
echo "作成した右上画像: ${RT_OWNER_IMAGE_FILE_PATH}"

# 左上の動画テーマ画像作成
./core/createMovieThemeImageLT.sh $LT_THEME_IMAGE_FILE_PATH $FONT_FILE_PATH $LEFT_TOP_TEXT
echo "作成した左上画像: ${LT_THEME_IMAGE_FILE_PATH}"

# 右下の動画トピック画像作成
./core/createMovieTopicImageRB.sh $RB_TOPIC_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_BOTTOM_TEXT
echo "作成した右下画像: ${RB_TOPIC_IMAGE_FILE_PATH}"

# ベース動画作成
./core/createBasePartMovie.sh $BASE_PART_MOVIE_FILE_PATH $CENTER_IMAGE_LIST_FILE_PATH $RT_OWNER_IMAGE_FILE_PATH $LT_THEME_IMAGE_FILE_PATH $RB_TOPIC_IMAGE_FILE_PATH $LB_NARRATOR_IMAGE_FILE_PATH $BACKGROUND_IMAGE_FILE_PATH
echo "作成したベース動画: ${BASE_PART_MOVIE_FILE_PATH}"

# フェード動画を作成し、ベース動画と結合
./core/mergeBaseAndFadeMovie.sh $MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $CENTER_IMAGE_LIST_FILE_PATH $BASE_PART_MOVIE_FILE_PATH
echo "パート動画ディレクトリ: ${MOVIE_PART_DIR_PATH}"

# パートファイル一覧から結合動画を作成
./core/concatMovieFromList.sh $OUTPUT_MOVIE_FILE_PATH $MOVIE_PART_LIST_FILE_PATH
echo "作成したメインパート動画: ${OUTPUT_MOVIE_FILE_PATH}"

# パート動画のディレクトリを削除
rm -rf $MOVIE_PART_DIR_PATH

