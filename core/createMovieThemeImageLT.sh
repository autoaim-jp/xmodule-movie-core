#!/bin/bash

LEFT_TOP_IMAGE=${1:-/tmp/left_top.png}
FONT_FILE_PATH=${2:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}
LEFT_TOP_TEXT=${3:-"株式グラフ管理Webアプリ"}

# 左上の画像作成
convert -size 655x100 xc:none \
    -fill '#ebebeb' -stroke '#f16529' -strokewidth 2 \
    -draw "polygon 10,25 600,25 650,50 600,75 10,75" \
    -fill '#f16529' -stroke black -strokewidth 3 \
    -draw "polyline 5,70 20,40 35,60 50,30 65,50 80,15" \
    -font $FONT_FILE_PATH -pointsize 38 \
    -stroke black -fill '#f16529' -strokewidth 2 \
    -draw "text 120,65 '"${LEFT_TOP_TEXT}"'" \
    $LEFT_TOP_IMAGE

