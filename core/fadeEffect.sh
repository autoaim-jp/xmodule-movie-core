#!/bin/bash

TMP_FADEIN_FILE_PATH="${PWD}/data/tmp/tmp/__fadein.mp4"
TITLE_IMG_FILE_PATH=${1:-"${PWD}/data/src/project/sample/title.png"}
TITLE_MOVIE_FILE_PATH=${2:-/tmp/title.mp4}

ffmpeg -loop 1 -i $TITLE_IMG_FILE_PATH -vf "fade=in:0:30" -t 5 $TMP_FADEIN_FILE_PATH

ffmpeg -i $TMP_FADEIN_FILE_PATH -vf "fade=out:120:30" $TITLE_MOVIE_FILE_PATH
