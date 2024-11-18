#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
##SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
CAPTURE_MOVIE_FILE_PATH=${1:-/tmp/capture.mp4}

# input
TMP_CAPTURE_FILE_PATH="${TMP_DIR_PATH}__capture.mp4"

# 画面キャプチャ撮影
ffmpeg -analyzeduration 10M -probesize 32M -y -f x11grab -video_size 1920x1080 -i :1.0+0,0 -framerate 60 $TMP_CAPTURE_FILE_PATH

# キャプチャ動画の前後1秒は端末操作なので消す
ffmpeg -ss 1 -i $TMP_CAPTURE_FILE_PATH -filter_complex "[0]trim=1,setpts=PTS-STARTPTS[b];[b][0]overlay=shortest=1" -shortest -c:a copy $CAPTURE_MOVIE_FILE_PATH

