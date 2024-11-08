#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__fadeInOut_${CURRENT_TIME}/
center_image=${PWD}/data/src/project/sample/asset/graph.png        # 中央に表示する画像
BASE_MOVIE_PATH=${PWD}/data/src/project/sample/base.mp4
FADE_MOVIE_PATH=${TMP_DIR}image_fade.mov
OUTPUT_MOVIE_PATH=${TMP_DIR}output.mp4

mkdir -p $TMP_DIR

# 背景が透明ではない
#ffmpeg -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=4,fade=t=out:st=6:d=4" -t 10 -c:v libx264 -pix_fmt yuv420p image_fade.mp4
# 背景が透明
ffmpeg -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=4:alpha=1,fade=t=out:st=6:d=4:alpha=1" -t 10 -c:v qtrle $FADE_MOVIE_PATH

# 別動画の中央にフェードイン・アウトの動画をオーバーラップさせる
ffmpeg -i $BASE_MOVIE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,10)'" -c:a copy $OUTPUT_MOVIE_PATH

echo $TMP_DIR
xdg-open $TMP_DIR

