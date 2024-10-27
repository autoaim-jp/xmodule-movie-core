#!/bin/bash

TITLE_MOVIE_FILE_PATH=${1:-"${PWD}/data/src/project/sample/title_movie.mp4"}
CAPTURE_MOVIE_FILE_PATH=${2:-"${PWD}/data/src/project/sample/capture.mp4"}
CONCAT_MOVIE_FILE_PATH=${3:-/tmp/concat.mp4}

REENCODED_TITLE_MOVIE_FILE_PATH="${PWD}/data/tmp/tmp/__title_reencoded.mp4"
REENCODED_CAPTURE_MOVIE_FILE_PATH="${PWD}/data/tmp/tmp/__capture_reencoded.mp4"

# 同じ条件でエンコードし直す
ffmpeg -i $TITLE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_TITLE_MOVIE_FILE_PATH
ffmpeg -i $CAPTURE_MOVIE_FILE_PATH -r 60 -s 1920x1080 -c:v libx264 $REENCODED_CAPTURE_MOVIE_FILE_PATH

# タイトル動画とキャプチャ動画を結合する
ffmpeg -i $REENCODED_TITLE_MOVIE_FILE_PATH -i $REENCODED_CAPTURE_MOVIE_FILE_PATH -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[v]" -map "[v]" $CONCAT_MOVIE_FILE_PATH

