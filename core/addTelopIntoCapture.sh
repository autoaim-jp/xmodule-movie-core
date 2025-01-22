#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
MAIN_PART_MOVIE_FILE_PATH=${1:-"/tmp/telop_movie.mp4"}

# input
CAPTURE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}capture.mp4"}
RT_OWNER_IMAGE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}main_part/right_top.png"}
LT_THEME_IMAGE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}main_part/left_top.png"}
RB_TOPIC_IMAGE_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}main_part/right_bottom.png"}
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${SAMPLE_PROJECT_DIR_PATH}asset/woman_flop.png"}

# other
# 画像サイズと位置
output_width=1920                     # 出力動画の幅
output_height=1080                    # 出力動画の高さ
right_top_box_width=300               # 右上に表示するボックスの幅
right_top_box_height=100              # 右上ボックスの高さ
left_bottom_image_width=200           # 左下に表示するナレーター画像の幅
left_bottom_image_height=151          # 左下画像の高さ


ffmpeg -y -i "$CAPTURE_MOVIE_FILE_PATH" -i "$RT_OWNER_IMAGE_FILE_PATH" -i "$LT_THEME_IMAGE_FILE_PATH" -i "$RB_TOPIC_IMAGE_FILE_PATH" -i "$LB_NARRATOR_IMAGE_FILE_PATH" \
-filter_complex "\
    [1:v]scale=200:80[rt]; \
    [2:v]scale=655:100[lt]; \
    [3:v]scale=380:100[rb]; \
    [4:v]scale=${left_bottom_image_width}:${left_bottom_image_height}[lb]; \
    [0:v][rt]overlay=x=W-w-10:y=20[tmp1]; \
    [tmp1][lt]overlay=x=20:y=20[tmp2]; \
    [tmp2][rb]overlay=x=W-w-10:y=H-h-10[tmp3]; \
    [tmp3][lb]overlay=x=20:y=H-${left_bottom_image_height}-20" \
-c:v h264_nvenc $MAIN_PART_MOVIE_FILE_PATH

