#!/bin/bash

ROOT_DIR_PATH=${PWD}/
SUBTITLE_MOVIE_FILE_PATH=${1:--}

# ${ROOT_DIR_PATH}app/capture.sh
# ${ROOT_DIR_PATH}lib/rename_number_image.sh

${ROOT_DIR_PATH}app/speak_sound.sh

${ROOT_DIR_PATH}app/title_movie.sh

${ROOT_DIR_PATH}app/telop_image.sh

${ROOT_DIR_PATH}app/main_part_from_capture.sh
# ${ROOT_DIR_PATH}app/main_part_from_image_list.sh

${ROOT_DIR_PATH}app/concat_movie.sh

${ROOT_DIR_PATH}app/subtitle_movie.sh $SUBTITLE_MOVIE_FILE_PATH

# ${ROOT_DIR_PATH}lib/adjust_volume.sh

