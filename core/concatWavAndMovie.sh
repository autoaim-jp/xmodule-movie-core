#!/bin/bash

CONCAT_MOVIE_FILE_PATH=${1:-"${PWD}/data/src/project/sample/concat_movie.mp4"}
CONCAT_SOUND_FILE_PATH=${2:-"${PWD}/data/src/project/sample/concat_sound.wav"}
FINAL_MOVIE_FILE_PATH=${3:-/tmp/final.mp4}

# 動画ファイルと音声ファイルを結合する
ffmpeg -i $CONCAT_MOVIE_FILE_PATH -i $CONCAT_SOUND_FILE_PATH -c:v copy -c:a aac -strict experimental $FINAL_MOVIE_FILE_PATH


