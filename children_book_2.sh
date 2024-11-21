#!/bin/bash

# 定数
ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR_PATH="${DATA_DIR_PATH}tmp/tmp/${PROJECT_NAME}_${CURRENT_TIME}/"
PROJECT_NAME="children_book_2"
FONT_FILE_PATH="/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf"
BACKGROUND_IMAGE_FILE_PATH="${DATA_DIR_PATH}src/project/children_book_1/bg_ccffcc.png" # 背景画像パス

# output
OUTPUT_MOVIE_FILE_PATH=${1} # result.mp4

# input
NARRATION_FILE_PATH=${2} # narration.csv
TITLE_TEXT=${3} # 物語のタイトル
TITLE_IMAGE_FILE_PATH=${4} # 物語の表紙画像
TELOP_TEXT=${5} # 右上の画像
IMAGE_LIST_FILE_PATH=${6} # 挿絵のパスリスト
SUBTITLE_FILE_PATH=${7} # subtitle.csv

# tmp
mkdir -p "$TMP_DIR_PATH"
TMP_SOUND_FILE_PATH="${TMP_DIR_PATH}__speak_sound.wav"
TMP_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_movie.mp4"
TMP_RT_FILE_PATH="${TMP_DIR_PATH}__black_white_rt.png"
TMP_MAIN_PART_MOVIE_FILE_PATH="${TMP_DIR_PATH}__main_part_movie.mp4"
TMP_CONCAT_MOVIE_FILE_PATH="${TMP_DIR_PATH}__concat_movie.mp4"

# ./app/speak_sound.sh
./app/speak_sound.sh "$TMP_SOUND_FILE_PATH" "$NARRATION_FILE_PATH"

# ./app/title_movie.sh
./app/title_movie.sh "$TMP_TITLE_MOVIE_FILE_PATH" "$TITLE_TEXT" "$TITLE_IMAGE_FILE_PATH" 8

# ./app/telop_image.sh
./app/telop_image.sh - - "$TMP_RT_FILE_PATH" - - "$TELOP_TEXT" "$FONT_FILE_PATH"

# ./app/main_part_from_image_list.sh
./app/main_part_from_image_list.sh "$TMP_MAIN_PART_MOVIE_FILE_PATH" "$IMAGE_LIST_FILE_PATH" "$BACKGROUND_IMAGE_FILE_PATH" x "$TMP_BLACK_WHITE_TITLE_FILE_PATH" x x

# ./app/concat_movie.sh
./app/concat_movie.sh "$TMP_CONCAT_MOVIE_FILE_PATH" "$TMP_TITLE_MOVIE_FILE_PATH" "$TMP_MAIN_PART_MOVIE_FILE_PATH" "$TMP_SOUND_FILE_PATH"

# ./app/subtitle_movie.sh
./app/subtitle_movie.sh "$OUTPUT_MOVIE_FILE_PATH" "$TMP_CONCAT_MOVIE_FILE_PATH" "$SUBTITLE_FILE_PATH"

echo "作成した動画: $OUTPUT_MOVIE_FILE_PATH"

# 一時ディレクトリの削除
rm -rf "$TMP_DIR_PATH"

