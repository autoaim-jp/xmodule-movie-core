#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
##DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}asset/src/project/sample/
##CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  OUTPUT_FILE_PATH=$1
else
  OUTPUT_FILE_PATH=/tmp/output_volume_adjusted.mp4
fi

INPUT_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}concat_movie.mp4"}

# 0.5は半分
adjust=${3:-0.5}

# 音量を調整する
ffmpeg -y -i $INPUT_FILE_PATH -af "volume=${adjust}" -c:v copy -c:a aac ${OUTPUT_FILE_PATH}

echo "音量調整済みファイル: ${OUTPUT_FILE_PATH}"

