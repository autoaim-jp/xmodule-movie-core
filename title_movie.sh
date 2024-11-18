#!/bin/bash

SCRIPT_DIR_PATH=${PWD}/
DATA_DIR_PATH="${SCRIPT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/title_movie/
mkdir -p $OUTPUT_DIR_PATH
TITLE_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4

# input
TITLE_TEXT=${1:-"Sampleアプリ\n操作方法の紹介"}
LOGO_IMG_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}logo.webp"}
TITLE_SEC=${3:-5}

# tmp 
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/title_movie/
mkdir -p $TMP_DIR_PATH
TITLE_IMG_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}.png

# タイトル画像作成
./core/createTitleImage.sh $TITLE_IMG_FILE_PATH $TITLE_TEXT $LOGO_IMG_FILE_PATH
echo "作成したタイトル画像: $TITLE_IMG_FILE_PATH"

# フェードインとフェードアウトの動画
./core/fadeEffect.sh $TITLE_MOVIE_FILE_PATH $TITLE_IMG_FILE_PATH $TITLE_SEC
echo "作成したタイトル動画: $TITLE_MOVIE_FILE_PATH"

