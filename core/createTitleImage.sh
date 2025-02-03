#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../asset/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
TITLE_IMG_FILE_PATH=${1:-/tmp/title.png}

# input
TITLE_TEXT=${2:-Webサービス名\n操作方法の紹介}
LOGO_IMG_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}logo.webp"}
FONT_FILE_PATH=${4:-"${SCRIPT_DIR_PATH}../asset/SourceHanSans-Bold.otf"}

# tmp
TMP_IMG_FILE_PATH="${TMP_DIR_PATH}__title.png"
TMP_RESIZED_LOGO_PATH="${TMP_DIR_PATH}__logo_resized.png"

# other
text_pos_x="+0"
text_pos_y="-150"

# 文字の画像を生成
# convert -size 1920x1080 xc:"#CCFFCC" -gravity center -pointsize 72 -font $FONT_FILE_PATH -annotate "${text_pos_x}${text_pos_y}" "$TITLE_TEXT" $TMP_IMG_FILE_PATH
convert -size 1920x1080 xc:"#004896" -gravity center -pointsize 72 -font $FONT_FILE_PATH -annotate "${text_pos_x}${text_pos_y}" "$TITLE_TEXT" $TMP_IMG_FILE_PATH

# ロゴ画像をリサイズ
convert $LOGO_IMG_FILE_PATH -resize 500x $TMP_RESIZED_LOGO_PATH

# ロゴ画像を配置
convert $TMP_IMG_FILE_PATH $TMP_RESIZED_LOGO_PATH  \
-gravity south -geometry +0+50 -composite $TITLE_IMG_FILE_PATH

