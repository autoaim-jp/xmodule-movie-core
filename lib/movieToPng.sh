#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__movieToPng_${CURRENT_TIME}/
INPUT_FILE_PATH=${1:-"${PWD}/data/src/project/sample/title_movie.mp4"}

mkdir $TMP_DIR

# 全フレーム
# ffmpeg -i $INPUT_FILE_PATH ${TMP_DIR}output_%04d.png
# 1秒1フレーム
ffmpeg -i $INPUT_FILE_PATH -vf "fps=1" ${TMP_DIR}output_%04d.png
# 10秒1フレーム
# ffmpeg -i $INPUT_FILE_PATH -vf "fps=1/10" ${TMP_DIR}output_%04d.png

echo $TMP_DIR
xdg-open $TMP_DIR

