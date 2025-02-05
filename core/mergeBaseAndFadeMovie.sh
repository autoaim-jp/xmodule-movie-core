#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../asset/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
MOVIE_PART_LIST_FILE_PATH=${1:-/tmp/part_list.txt}
MOVIE_PART_DIR_PATH=${2:-/tmp/__demo_video_creator/}
mkdir -p $MOVIE_PART_DIR_PATH

# input
CENTER_IMAGE_LIST_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number.txt"}
BASE_MOVIE_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}main_part/base.mp4"}
CENTER_BACKGROUND_IMAGE_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}asset/background_1024.jpg"}

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

    # パート動画のファイルパス 絶対パス
    movie_part_file_path=$(realpath ${MOVIE_PART_DIR_PATH}part_$(printf "%04d" $n).mp4)

    fade_out_start=$((part_sec - fade_out_sec))
    # 画像からフェード動画作成 背景は透明で、フェードイン、表示、フェードアウトする動画パーツ
    # h264_nvencはアルファチャンネルに対応していない。そのためフェードができなくなった。
    #ffmpeg -y -loop 1 -i $file_path -vf "scale=${center_image_width}:${center_image_height},format=rgba,fade=t=in:st=0:d=${fade_in_sec}:alpha=1,fade=t=out:st=${fade_out_start}:d=${fade_out_sec}:alpha=1,format=yuv420p" -t ${part_sec} -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $FADE_MOVIE_PATH < /dev/null
    # 右から左に移動する動画パーツ
    ffmpeg -y -loop 1 -framerate 60 -t ${part_sec} -i "$CENTER_BACKGROUND_IMAGE_FILE_PATH" -i "$file_path" -filter_complex "[0:v][1:v]overlay=x='if(lt(t,${fade_in_sec}),1024-1024*t/2,if(gt(t,${fade_out_start}),-1024*(t-${fade_out_start})/2,0))':y='0',scale=1024:1024" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast -r 60 $FADE_MOVIE_PATH < /dev/null

    # ベース動画とフェード動画から動画パート作成
    ffmpeg -y -i $BASE_MOVIE_FILE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,${part_sec})'" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $movie_part_file_path < /dev/null

    # 結合するファイル一覧にファイルパス追加
    echo "file '${movie_part_file_path}'" >> $MOVIE_PART_LIST_FILE_PATH
    
    # sum_part_secの更新
    sum_part_sec=$((sum_part_sec + part_sec))

    # カウントアップ
    ((n++))
done

