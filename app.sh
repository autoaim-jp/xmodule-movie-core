#!/bin/bash

DATA_DIR=./data/tmp/title_image/
TITLE_IMG_FILE_NAME=$(date '+%Y%m%d_%H%M%S').png

TITLE_TEXT=${1:-"Sampleアプリ\n操作方法の紹介"}

# タイトル画像作成
./core/createTitleImage.sh ${DATA_DIR}${TITLE_IMG_FILE_NAME} ${TITLE_TEXT}


# tmpディレクトリのクリーンアップ
rm ./data/tmp/tmp/*
