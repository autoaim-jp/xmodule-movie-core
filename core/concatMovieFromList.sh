#!/bin/bash

OUTPUT_MOVIE_FILE_PATH=${1:-/tmp/output.mp4}
MOVIE_PART_LIST_FILE_PATH=${2:-"${PWD}/data/src/project/sample/main_part/part_list.txt"}

# 結合ファイル一覧から結合動画作成
ffmpeg -f concat -safe 0 -i $MOVIE_PART_LIST_FILE_PATH -c:a copy $OUTPUT_MOVIE_FILE_PATH < /dev/null

