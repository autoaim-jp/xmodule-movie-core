#!/bin/bash

DATA_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
CAPTURE_MOVIE_FILE_PATH=${1:-"${PWD}/data/src/sample/capture.mp4"}
SUBTITLE_MOVIE_FILE_PATH=${DATA_PATH}tmp/capture_subtitle/${CURRENT_TIME}.mp4

./core/addSubtitle.sh $CAPTURE_MOVIE_FILE_PATH $SUBTITLE_MOVIE_FILE_PATH
echo "字幕動画: $SUBTITLE_MOVIE_FILE_PATH"
# xdg-open $SUBTITLE_MOVIE_FILE_PATH

