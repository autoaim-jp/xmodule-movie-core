#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
BASE_MOVIE_PATH=${1:-"${SAMPLE_PROJECT_DIR_PATH}main_part/base.mp4"}  # ベース動画

# input
CENTER_IMAGE_LIST_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number.txt"}  # 中央に標示する画像のリスト
RT_OWNER_IMAGE_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}main_part/right_top.png"}
LT_THEME_IMAGE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}main_part/left_top.png"}
RB_TOPIC_IMAGE_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}main_part/right_bottom.png"}
LB_NARRATOR_IMAGE_FILE_PATH=${6:-"${SAMPLE_PROJECT_DIR_PATH}asset/woman_flop.png"}    # 左下に表示する画像
BACKGROUND_IMAGE_FILE_PATH=${7:-"${SAMPLE_PROJECT_DIR_PATH}asset/background.jpg"}    # 全画面の背景画像

# other
# 画像サイズと位置
output_width=1920                     # 出力動画の幅
output_height=1080                    # 出力動画の高さ
right_top_box_width=300               # 右上に表示するボックスの幅
right_top_box_height=100              # 右上ボックスの高さ
center_image_width=600                # 中央画像の幅
center_image_height=400               # 中央画像の高さ
subtitle_box_height=50                # 中央下の字幕ボックスの高さ
left_bottom_image_width=200           # 左下に表示するナレーター画像の幅
left_bottom_image_height=151          # 左下画像の高さ

# total_part_secの初期値を設定
total_part_sec=0

# total_part_secの最終の値を確認
while IFS=',' read -r part_sec fade_in_sec fade_out_sec filePath
do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ "$part_sec" =~ ^#.* ]] || [[ -z "$part_sec" ]]; then
        continue
    fi
    # total_part_secの更新
    total_part_sec=$((total_part_sec + part_sec))
done < "$CENTER_IMAGE_LIST_FILE_PATH"

echo $total_part_sec

# ベース動画作成　BG画像表示。四隅に画像配置
ffmpeg -y -i "$BACKGROUND_IMAGE_FILE_PATH" -i "$LB_NARRATOR_IMAGE_FILE_PATH" -i "$RT_OWNER_IMAGE_FILE_PATH" -i "$RB_TOPIC_IMAGE_FILE_PATH" -i "$LT_THEME_IMAGE_FILE_PATH" \
-filter_complex "\
    [0:v]scale=${output_width}:${output_height}[bg]; \
    [2:v]scale=200:80[scaled_right_top_image]; \
    [3:v]scale=380:100[scaled_right_bottom_image]; \
    [4:v]scale=655:100[scaled_left_top_image]; \
    [bg][scaled_left_top_image]overlay=x=20:y=20[bg_with_left_top_image]; \
    [bg_with_left_top_image][scaled_right_top_image]overlay=x=W-w-10:y=20[bg_with_right_top_image]; \
    [1:v]scale=${left_bottom_image_width}:${left_bottom_image_height}[bottom_left_img]; \
    [bg_with_right_top_image][bottom_left_img]overlay=x=20:y=H-${left_bottom_image_height}-20[bg_with_left_bottom_image]; \
    [bg_with_left_bottom_image][scaled_right_bottom_image]overlay=x=W-w-10:y=H-h-10" \
-c:v libx264 -t $total_part_sec -pix_fmt yuv420p $BASE_MOVIE_PATH

