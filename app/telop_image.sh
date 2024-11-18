#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/telop_image/
mkdir -p $OUTPUT_DIR_PATH
RT_OWNER_IMAGE_FILE_PATH=${OUTPUT_DIR_PATH}right_top_owner.png
LT_THEME_IMAGE_FILE_PATH=${OUTPUT_DIR_PATH}left_top_theme.png
RB_TOPIC_IMAGE_FILE_PATH=${OUTPUT_DIR_PATH}right_bottom_topic.png

# input
RIGHT_TOP_TEXT=${1:-"動画さん"}
LEFT_TOP_TEXT=${2:-"研修カリキュラム自動作成"}
RIGHT_BOTTOM_TEXT=${3:-"このアプリの使い方"}
FONT_FILE_PATH=${4:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}

# 右上の動画オーナー画像作成
${ROOT_DIR_PATH}core/createOwnerImageRT.sh $RT_OWNER_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_TOP_TEXT
echo "作成した右上画像: ${RT_OWNER_IMAGE_FILE_PATH}"

# 左上の動画テーマ画像作成
${ROOT_DIR_PATH}core/createMovieThemeImageLT.sh $LT_THEME_IMAGE_FILE_PATH $FONT_FILE_PATH $LEFT_TOP_TEXT
echo "作成した左上画像: ${LT_THEME_IMAGE_FILE_PATH}"

# 右下の動画トピック画像作成
${ROOT_DIR_PATH}core/createMovieTopicImageRB.sh $RB_TOPIC_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_BOTTOM_TEXT
echo "作成した右下画像: ${RB_TOPIC_IMAGE_FILE_PATH}"

