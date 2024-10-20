#!/bin/bash

TMP_IMG_FILE_PATH="${PWD}/data/tmp/tmp/__title.png"
TMP_RESIZED_LOGO_PATH="${PWD}/data/tmp/tmp/__logo_resized.png"
TITLE_IMG_FILE_PATH=${1:-/tmp/title.png}
TITLE_TEXT=${2:-Webサービス名\n操作方法の紹介}
LOGO_IMG_FILE_PATH=${3:-"${PWD}/data/src/logo/logo.webp"}

# 文字の画像を生成
convert -size 1920x1080 xc:"#CCFFCC" -gravity center -pointsize 72 -font /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf -annotate +0-100 "$TITLE_TEXT" $TMP_IMG_FILE_PATH

# ロゴ画像をリサイズ
convert $LOGO_IMG_FILE_PATH -resize 500x $TMP_RESIZED_LOGO_PATH

# ロゴ画像を配置
convert $TMP_IMG_FILE_PATH $TMP_RESIZED_LOGO_PATH  \
-gravity south -geometry +0+50 -composite $TITLE_IMG_FILE_PATH

