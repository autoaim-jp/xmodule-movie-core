#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  SUBTITLE_MOVIE_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/subtitle_movie/ 
  mkdir -p $OUTPUT_DIR_PATH
  SUBTITLE_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4
fi

# input
CAPTURE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}concat_movie.mp4"}
SUBTITLE_TEXT_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}subtitle.csv"}

${ROOT_DIR_PATH}core/addSubtitle.sh $SUBTITLE_MOVIE_FILE_PATH $CAPTURE_MOVIE_FILE_PATH $SUBTITLE_TEXT_FILE_PATH
echo "字幕動画: $SUBTITLE_MOVIE_FILE_PATH"
# xdg-open $SUBTITLE_MOVIE_FILE_PATH

