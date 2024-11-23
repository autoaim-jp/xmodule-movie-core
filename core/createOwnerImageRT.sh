#!/bin/bash

##SCRIPT_DIR_PATH=$(dirname "$0")/
##SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
RIGHT_TOP_IMAGE=${1:-/tmp/right_top.png}

# input
FONT_FILE_PATH=${2:-"${SCRIPT_DIR_PATH}../asset/SourceHanSans-Bold.otf"}
RIGHT_TOP_TEXT=${3:-"研修くん"}

# 右上の画像作成
convert -size 200x80 xc:none \
    -fill "#f16529" -draw "roundrectangle 0,0 200,80 15,15" \
    -gravity center \
    -font $FONT_FILE_PATH \
    -pointsize 40 -fill white -annotate 0 "$RIGHT_TOP_TEXT" \
    $RIGHT_TOP_IMAGE

