#!/bin/bash

DATA_DIR_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
CAPTURE_MOVIE_FILE_PATH=${DATA_DIR_PATH}capture/${CURRENT_TIME}.mp4

# ffmpeg -y -f x11grab -video_size 1920x1080 -i :1.0+0,0 -framerate 60 /tmp/capture.mp4
# キャプチャし、最初と最後の1秒をトリミングする
./core/captureAndTrim.sh $CAPTURE_MOVIE_FILE_PATH
echo "キャプチャ: $CAPTURE_MOVIE_FILE_PATH"
# xdg-open $CAPTURE_MOVIE_FILE_PATH

# tmpディレクトリのクリーンアップ
rm ./data/tmp/tmp/*

