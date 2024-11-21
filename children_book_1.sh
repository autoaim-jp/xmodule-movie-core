#!/bin/bash

TMP_DIR_PATH=${PWD}/data/tmp/tmp/
OUTPUT_MOVIE_FILE_PATH=${PWD}/data/result/children_book_1/result.mp4

# ./app/capture.sh

./app/speak_sound.sh "${TMP_DIR_PATH}__speak_sound.wav" "${TMP_DIR_PATH}__subtitle.csv" "${TMP_DIR_PATH}__image_list.scv" ./data/src/project/children_book_1/narration.csv ${PWD}/data/src/project/children_book_1/asset_ordered/

./app/title_movie.sh "${TMP_DIR_PATH}__title_movie.mp4" "もりのぼうけんしゃ\nタケルとふしぎなタネ" ./data/src/project/children_book_1/dalle/title.webp 8

./app/telop_image.sh - - "${TMP_DIR_PATH}__black_white_title.png" - - "Tempura\nTitans" /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf

# ./app/main_part_from_capture.sh
# ./app/main_part_from_image_list.sh "${TMP_DIR_PATH}__main_part_movie.mp4" ./data/src/project/children_book_1/image_list.txt ./data/src/project/children_book_1/bg_ccffcc.png x "${TMP_DIR_PATH}__black_white_title.png" x x
./app/main_part_from_image_list.sh "${TMP_DIR_PATH}__main_part_movie.mp4" "${TMP_DIR_PATH}__image_list.scv" ./data/src/project/children_book_1/bg_ccffcc.png x "${TMP_DIR_PATH}__black_white_title.png" x x

./app/concat_movie.sh "${TMP_DIR_PATH}__concat_movie.mp4" "${TMP_DIR_PATH}__title_movie.mp4" "${TMP_DIR_PATH}__main_part_movie.mp4" "${TMP_DIR_PATH}__speak_sound.wav"

# ./app/subtitle_movie.sh "${OUTPUT_MOVIE_FILE_PATH}" "${TMP_DIR_PATH}__concat_movie.mp4" ./data/src/project/children_book_1/subtitle.csv
./app/subtitle_movie.sh "${OUTPUT_MOVIE_FILE_PATH}" "${TMP_DIR_PATH}__concat_movie.mp4" "${TMP_DIR_PATH}__subtitle.csv"
echo "作成した動画: ${OUTPUT_MOVIE_FILE_PATH}"

