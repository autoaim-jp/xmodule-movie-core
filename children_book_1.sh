#!/bin/bash

TMP_DIR_PATH=${PWD}/data/tmp/tmp/
OUTPUT_DIR_PATH=${PWD}/data/result/children_book_1/

# ./app/capture.sh

./app/title_movie.sh "${TMP_DIR_PATH}__title_movie.mp4" "もりのぼうけんしゃ\nタケルとふしぎなタネ" ./data/src/project/children_book_1/dalle/title.webp 8

./app/telop_image.sh - - "${TMP_DIR_PATH}__black_white_title.png" - - "Tempura Titans" /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf

# ./app/main_part_from_capture.sh
./app/main_part_from_image_list.sh "${TMP_DIR_PATH}__main_part_movie.mp4" ${PWD}/data/src/project/children_book_1/image_list.txt ${PWD}/data/src/project/children_book_1/bg_ccffcc.png x "${TMP_DIR_PATH}__black_white_title.png" x x

exit 0

./app/speak_sound.sh

./app/concat_movie.sh "${TMP_DIR_PATH}__title_movie.mp4"

./app/subtitle_movie.sh

