#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
MOVIE_PART_LIST_FILE_PATH=${1:-/tmp/part_list.txt}
MOVIE_PART_DIR_PATH=${2:-/tmp/__demo_video_creator/}
echo > $MOVIE_PART_LIST_FILE_PATH
mkdir -p $MOVIE_PART_DIR_PATH

# input
CENTER_IMAGE_LIST_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number.txt"}
BASE_MOVIE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}main_part/base.mp4"}

# tmp
FADE_MOVIE_PATH=${TMP_DIR_PATH}__image_fade.mov

# other
# 1920x1080ならこれがいい
# center_image_width=1422                # 中央画像の幅
# center_image_height=800               # 中央画像の高さ
center_image_width=1024                # 中央画像の幅
center_image_height=1024              # 中央画像の高さ

# 必要なもの: 動画パート時間(10),フェードイン(4),フェードアウト(4),画像パス→
# 計算で求められるもの: フェードアウト開始(6 動画パート時間(10)-フェードアウト(4)), オーバーラップさせる時間(t,0,10 これまでオーバーラップされた時間(変数sum_part_sec 動画パート時間の累積)と、それ+動画パート時間(10))

sum_part_sec=0
n=1
cat $CENTER_IMAGE_LIST_FILE_PATH | while IFS=',' read -r part_sec fade_in_sec fade_out_sec file_path; do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ -z "$part_sec" || "$part_sec" == \#* ]]; then
        continue
    fi

    # パート動画のファイルパス
    movie_part_file_path=${MOVIE_PART_DIR_PATH}part_$(printf "%04d" $n).mp4

    # 画像からフェード動画作成 背景は透明で、フェードイン、表示、フェードアウトする動画パーツ
    fade_out_start=$((part_sec - fade_out_sec))
    ffmpeg -y -loop 1 -i $file_path -vf "scale=${center_image_width}:${center_image_height},format=rgba,fade=t=in:st=0:d=${fade_in_sec}:alpha=1,fade=t=out:st=${fade_out_start}:d=${fade_out_sec}:alpha=1" -t ${part_sec} -c:v qtrle $FADE_MOVIE_PATH < /dev/null
    
    # ベース動画とフェード動画から動画パート作成
    ffmpeg -y -i $BASE_MOVIE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,${part_sec})'" -c:a copy $movie_part_file_path < /dev/null

    # 結合するファイル一覧にファイルパス追加
    echo "file '${movie_part_file_path}'" >> $MOVIE_PART_LIST_FILE_PATH
    
    # sum_part_secの更新
    sum_part_sec=$((sum_part_sec + part_sec))

    # カウントアップ
    ((n++))
done

