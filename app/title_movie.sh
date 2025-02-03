#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}asset/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  TITLE_MOVIE_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/title_movie/
  mkdir -p $OUTPUT_DIR_PATH
  TITLE_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4
fi

# input
TITLE_TEXT=${2:-"Sampleアプリ\n操作方法の紹介"}
LOGO_IMG_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}logo.webp"}
TITLE_SEC=${4:-5}
FONT_FILE_PATH=${5:-"${ROOT_DIR_PATH}asset/SourceHanSans-Bold.otf"}

# tmp 
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/title_movie/
mkdir -p $TMP_DIR_PATH
TITLE_IMG_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}.png

# タイトル画像作成
${ROOT_DIR_PATH}core/createTitleImage.sh $TITLE_IMG_FILE_PATH $TITLE_TEXT $LOGO_IMG_FILE_PATH $FONT_FILE_PATH
echo "作成したタイトル画像: $TITLE_IMG_FILE_PATH"

# フェードインとフェードアウトの動画
${ROOT_DIR_PATH}core/fadeEffect.sh $TITLE_MOVIE_FILE_PATH $TITLE_IMG_FILE_PATH $TITLE_SEC
echo "作成したタイトル動画: $TITLE_MOVIE_FILE_PATH"

