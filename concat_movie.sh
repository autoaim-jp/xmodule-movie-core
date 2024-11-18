#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/concat_movie/ 
mkdir -p $OUTPUT_DIR_PATH
FINAL_MOVIE_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.mp4

# input
TITLE_MOVIE_FILE_PATH=${1:-"${DATA_DIR_PATH}/src/project/sample/title_movie.mp4"}
SUBTITLE_MOVIE_FILE_PATH=${2:-"${DATA_DIR_PATH}/src/project/sample/capture_subtitle.mp4"}
CONCAT_SOUND_FILE_PATH=${3:-"${DATA_DIR_PATH}/src/project/sample/concat_sound.wav"}

# tmp
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/concat_movie/ 
mkdir -p $TMP_DIR_PATH
CONCAT_MOVIE_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}.mp4

./core/concatMovie.sh $TITLE_MOVIE_FILE_PATH $SUBTITLE_MOVIE_FILE_PATH $CONCAT_MOVIE_FILE_PATH
echo "タイトルとキャプチャの結合動画: $CONCAT_MOVIE_FILE_PATH"

./core/concatWavAndMovie.sh $CONCAT_SOUND_FILE_PATH $CONCAT_MOVIE_FILE_PATH $FINAL_MOVIE_FILE_PATH
echo "動画と音声の結合結果: $FINAL_MOVIE_FILE_PATH"
