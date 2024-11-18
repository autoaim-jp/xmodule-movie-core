#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
CAPTURE_MOVIE_FILE_PATH=${DATA_DIR_PATH}capture/${CURRENT_TIME}.mp4

# ffmpeg -y -f x11grab -video_size 1920x1080 -i :1.0+0,0 -framerate 60 /tmp/capture.mp4
# キャプチャし、最初と最後の1秒をトリミングする
${ROOT_DIR_PATH}core/captureAndTrim.sh $CAPTURE_MOVIE_FILE_PATH
echo "前後一秒をトリムしたキャプチャ: $CAPTURE_MOVIE_FILE_PATH"

