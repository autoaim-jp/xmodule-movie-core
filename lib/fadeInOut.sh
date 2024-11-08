#!/bin/bash

center_image=${PWD}/data/src/project/sample/asset/graph.png        # 中央に表示する画像

# 背景が透明ではない
#ffmpeg -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=4,fade=t=out:st=6:d=4" -t 10 -c:v libx264 -pix_fmt yuv420p image_fade.mp4
# 背景が透明
ffmpeg -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=4:alpha=1,fade=t=out:st=6:d=4:alpha=1" -t 10 -c:v qtrle image_fade.mov

# 別動画の中央にフェードイン・アウトの動画をオーバーラップさせる
ffmpeg -i output_video.mp4 -i image_fade.mov -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,10)'" -c:a copy output_video2.mp4

