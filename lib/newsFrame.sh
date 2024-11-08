#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__newsFrame_${CURRENT_TIME}/
background_image=${PWD}/data/src/project/sample/asset/background.jpg    # 全画面の背景画像
center_image=${PWD}/data/src/project/sample/asset/graph.png        # 中央に表示する画像
subtitle_text="字幕の文章"           # 中央下に表示する文章
bottom_left_image=${PWD}/data/src/project/sample/asset/woman_flop.png    # 左下に表示する画像

FADE_MOVIE_PATH=${TMP_DIR}image_fade.mov
OUTPUT_MOVIE_PATH=${TMP_DIR}output.mp4
BASE_MOVIE_PATH=${TMP_DIR}base.mp4

mkdir -p $TMP_DIR

# 画像サイズと位置
output_width=1920                     # 出力動画の幅
output_height=1080                    # 出力動画の高さ
right_top_box_width=300               # 右上に表示するボックスの幅
right_top_box_height=100              # 右上ボックスの高さ
center_image_width=600                # 中央画像の幅
center_image_height=400               # 中央画像の高さ
subtitle_box_height=50                # 中央下の字幕ボックスの高さ
left_bottom_image_width=200           # 左下に表示するナレーター画像の幅
left_bottom_image_height=151          # 左下画像の高さ

# 背景が透明で、フェードイン、フェードアウトの動画パーツ
ffmpeg -y -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=4:alpha=1,fade=t=out:st=6:d=4:alpha=1" -t 10 -c:v qtrle $FADE_MOVIE_PATH

#    [bg_with_box]drawtext=text='デモ動画':fontcolor=white:fontsize=30:x=W-tw-30:y=30[bg_with_text]; \

# FFmpegコマンド
ffmpeg -y -i "$background_image" -i "$bottom_left_image" \
-filter_complex "\
    [0:v]scale=${output_width}:${output_height}[bg]; \
    color=s=${right_top_box_width}x${right_top_box_height}:c=blue[box]; \
    [bg][box]overlay=x=W-w-10:y=20[bg_with_box]; \
    [bg_with_box]drawtext=text='デモ動画':fontcolor=white:fontsize=60:x=W-tw-40:y=40[bg_with_text]; \
    [1:v]scale=${left_bottom_image_width}:${left_bottom_image_height}[bottom_left_img]; \
    [bg_with_text][bottom_left_img]overlay=x=20:y=H-${left_bottom_image_height}-20" \
-c:v libx264 -t 10 -pix_fmt yuv420p $BASE_MOVIE_PATH

# lib/fadeInOut.shと同じ
# 別動画の中央にフェードイン・アウトの動画をオーバーラップさせる
ffmpeg -y -i $BASE_MOVIE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,10)'" -c:a copy $OUTPUT_MOVIE_PATH

echo $TMP_DIR
xdg-open $TMP_DIR

