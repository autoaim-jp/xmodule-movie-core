#!/bin/bash

DATA_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TITLE_IMG_FILE_PATH=${DATA_PATH}tmp/title_image/${CURRENT_TIME}.png
TITLE_MOVIE_FILE_PATH=${DATA_PATH}tmp/title_movie/${CURRENT_TIME}.mp4

TITLE_TEXT=${1:-"Sampleアプリ\n操作方法の紹介"}

# タイトル画像作成
./core/createTitleImage.sh $TITLE_IMG_FILE_PATH $TITLE_TEXT
echo "作成したタイトル画像: $TITLE_IMG_FILE_PATH"
# xdg-open $TITLE_IMG_FILE_PATH

# フェードインとフェードアウトの動画
./core/fadeEffect.sh $TITLE_IMG_FILE_PATH $TITLE_MOVIE_FILE_PATH
echo "作成したタイトル動画: $TITLE_MOVIE_FILE_PATH"
# xdg-open $TITLE_MOVIE_FILE_PATH

# tmpディレクトリのクリーンアップ
rm ./data/tmp/tmp/*

