#!/bin/bash

DATA_DIR_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
FINAL_MOVIE_FILE_PATH=${DATA_DIR_PATH}generated/concat_movie/${CURRENT_TIME}.mp4

# input
TITLE_MOVIE_FILE_PATH=${1:-"${DATA_DIR_PATH}/src/project/sample/title_movie.mp4"}
SUBTITLE_MOVIE_FILE_PATH=${2:-"${DATA_DIR_PATH}/src/project/sample/capture_subtitle.mp4"}
CONCAT_SOUND_FILE_PATH=${3:-"${DATA_DIR_PATH}/src/project/sample/concat_sound.wav"}

# tmp
CONCAT_MOVIE_FILE_PATH=${DATA_DIR_PATH}tmp/concat_movie/${CURRENT_TIME}.mp4

./core/concatMovie.sh $TITLE_MOVIE_FILE_PATH $SUBTITLE_MOVIE_FILE_PATH $CONCAT_MOVIE_FILE_PATH
echo "タイトルとキャプチャの結合動画: $CONCAT_MOVIE_FILE_PATH"

./core/concatWavAndMovie.sh $CONCAT_SOUND_FILE_PATH $CONCAT_MOVIE_FILE_PATH $FINAL_MOVIE_FILE_PATH
echo "動画と音声の結合結果: $FINAL_MOVIE_FILE_PATH"

