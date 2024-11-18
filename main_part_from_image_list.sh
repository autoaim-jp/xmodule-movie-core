#!/bin/bash

DATA_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

OUTPUT_MOVIE_FILE_PATH=${1:-"${DATA_PATH}generated/main_part_from_image_list/${CURRENT_TIME}.mp4"}

RIGHT_BOTTOM_TEXT=${3:-"このアプリの使い方"}
LEFT_TOP_TEXT=${3:-"株式グラフ管理Webアプリ"}
RIGHT_TOP_TEXT=${3:-"研修くん"}
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${DATA_PATH}src/project/sample/asset/woman_flop.png"}
FONT_FILE_PATH=${2:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}

CAPTURE_MOVIE_FILE_PATH=${1:-"${DATA_PATH}src/project/sample/capture.mp4"}
SUBTITLE_TEXT_FILE_PATH=${2:-"${DATA_PATH}src/project/sample/subtitle.csv"}
BACKGROUND_IMAGE_FILE_PATH=${7:-"${DATA_PATH}src/project/sample/asset/background.jpg"}
CENTER_IMAGE_LIST_FILE_PATH=${5:-"${DATA_PATH}src/project/sample/image_list_number.txt"}

RT_OWNER_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/right_top_owner.png
LT_THEME_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/left_top_theme.png
RB_TOPIC_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/right_bottom_topic.png
BASE_PART_MOVIE_FILE_PATH=${DATA_PATH}tmp/main_part_from_image_list/base.mp4
MOVIE_PART_DIR_PATH=${DATA_PATH}tmp/main_part_from_image_list/${CURRENT_TIME}/
MOVIE_PART_LIST_FILE_PATH=${DATA_PATH}tmp/main_part_from_image_list/part_list.txt

# 右上の動画オーナー画像作成
./core/createOwnerImageRT.sh $RT_OWNER_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_TOP_TEXT

# 左上の動画テーマ画像作成
./core/createMovieThemeImageLT.sh $LT_THEME_IMAGE_FILE_PATH $FONT_FILE_PATH $LEFT_TOP_TEXT

# 右下の動画トピック画像作成
./core/createMovieTopicImageRB.sh $RB_TOPIC_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_BOTTOM_TEXT

# ベース動画作成
./core/createBasePartMovie.sh $BASE_PART_MOVIE_FILE_PATH $CENTER_IMAGE_LIST_FILE_PATH $RT_OWNER_IMAGE_FILE_PATH $LT_THEME_IMAGE_FILE_PATH $RB_TOPIC_IMAGE_FILE_PATH $LB_NARRATOR_IMAGE_FILE_PATH $BACKGROUND_IMAGE_FILE_PATH

# フェード動画を作成し、ベース動画と結合
./core/mergeBaseAndFadeMovie.sh $MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $CENTER_IMAGE_LIST_FILE_PATH $BASE_PART_MOVIE_FILE_PATH

# パートファイル一覧から結合動画を作成
./core/concatMovieFromList.sh /tmp/output.mp4 $MOVIE_PART_LIST_FILE_PATH

