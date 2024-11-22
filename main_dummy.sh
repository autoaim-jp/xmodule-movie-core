#!/bin/bash

SUBTITLE_MOVIE_FILE_PATH=${1:--}

# ./app/capture.sh
# ./lib/rename_number_image.sh

./app/speak_sound.sh

./app/title_movie.sh

./app/telop_image.sh

./app/main_part_from_capture.sh
# ./app/main_part_from_image_list.sh

./app/concat_movie.sh

./app/subtitle_movie.sh $SUBTITLE_MOVIE_FILE_PATH

# ./lib/adjust_volume.sh

