#!/bin/bash

# :TODO ディレクトリの使い方もう一度整理 README.md
# core単体をtmp.shから呼び出して /tmp/にファイルができるかどうか確認

DATA_PATH="${PWD}/data/" # TODO これ使うようにする
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
CAPTURE_MOVIE_FILE_PATH=${1:-"${PWD}/data/src/project/sample/capture.mp4"}
SUBTITLE_TEXT_FILE_PATH=${2:-"${PWD}/data/src/project/sample/subtitle.csv"}

MOVIE_PART_LIST_FILE_PATH=${3:-"/tmp/part_list.txt"}
MOVIE_PART_DIR_PATH=${4:-/tmp/__demo_video_creator/}  # 作成できた動画
CENTER_IMAGE_LIST_FILE_PATH=${5:-"${PWD}/data/src/project/sample/image_list_number.txt"}  # 中央に標示する画像のリスト
BASE_MOVIE_PATH=/tmp/base.mp4  # ベース動画
FONT_FILE_PATH=${2:-/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf}
RIGHT_BOTTOM_TEXT=${3:-"このアプリの使い方"}

RT_OWNER_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/right_top_owner.png
LT_THEME_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/left_top_theme.png
RB_TOPIC_IMAGE_FILE_PATH=${DATA_PATH}tmp/main_part/right_bottom_topic.png
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${PWD}/data/src/project/sample/asset/woman_flop.png"}    # 左下に表示する画像
BACKGROUND_IMAGE_FILE_PATH=${7:-"${PWD}/data/src/project/sample/asset/background.jpg"}    # 全画面の背景画像

# 右上の動画オーナー画像作成
./core/createOwnerImageRT.sh $RT_OWNER_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_TOP_TEXT

# 左上の動画テーマ画像作成
./core/createMovieThemeImageLT.sh $LT_THEME_IMAGE_FILE_PATH $FONT_FILE_PATH $LEFT_TOP_TEXT

# 右下の動画トピック画像作成
./core/createMovieTopicImageRB.sh $RB_TOPIC_IMAGE_FILE_PATH $FONT_FILE_PATH $RIGHT_BOTTOM_TEXT

# ベース動画作成
./core/createBasePartMovie.sh $BASE_PART_MOVIE_FILE_PATH $CENTER_IMAGE_LIST_FILE_PATH $RT_OWNER_IMAGE_FILE_PATH $LT_THEME_IMAGE_FILE_PATH $RB_TOPIC_IMAGE_FILE_PATH $LB_NARRATOR_IMAGE_FILE_PATH $BACKGROUND_IMAGE_FILE_PATH

# フェード動画を作成し、ベース動画と結合
./core/mergeBaseAndFadeMovie.sh $MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $CENTER_IMAGE_LIST_FILE_PATH $BASE_MOVIE_PATH

# パートファイル一覧から結合動画を作成
./core/concatMovieFromList.sh /tmp/output.mp4 $MOVIE_PART_LIST_FILE_PATH

