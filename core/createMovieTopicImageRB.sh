#!/bin/bash

RIGHT_BOTTOM_IMAGE=${1:-/tmp/right_bottom.png}
FONT_FILE_PATH=${2:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}
RIGHT_BOTTOM_TEXT=${3:-"このアプリの使い方"}
RIGHT_BOTTOM_IMAGE_tmp1=${PWD}/data/tmp/tmp/__right_bottom_tmp1.png
RIGHT_BOTTOM_IMAGE_tmp2=${PWD}/data/tmp/tmp/__right_bottom_tmp2.png


# 右下の画像作成
# まずは黒縁取り画像作成
convert -size 380x100 xc:none -font $FONT_FILE_PATH -pointsize 36 \
    -fill black -stroke black -strokewidth 7 -gravity center \
    -annotate 0 $RIGHT_BOTTOM_TEXT $RIGHT_BOTTOM_IMAGE_tmp1

# 次に白い中の文字作成
convert -size 380x100 xc:none -font $FONT_FILE_PATH -pointsize 36 \
    -fill white -gravity center \
    -annotate 0 $RIGHT_BOTTOM_TEXT $RIGHT_BOTTOM_IMAGE_tmp2

# 画像を重ねる
convert $RIGHT_BOTTOM_IMAGE_tmp1 $RIGHT_BOTTOM_IMAGE_tmp2 -gravity center -composite $RIGHT_BOTTOM_IMAGE

