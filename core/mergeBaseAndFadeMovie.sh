#!/bin/bash

MOVIE_PART_LIST_FILE_PATH=${1:-/tmp/part_list.txt}  # 作成する動画のパス一覧
MOVIE_PART_DIR_PATH=${2:-/tmp/__demo_video_creator/}  # 作成できた動画
mkdir -p $MOVIE_PART_DIR_PATH
echo > $MOVIE_PART_LIST_FILE_PATH

CENTER_IMAGE_LIST_FILE_PATH=${3:-"${PWD}/data/src/project/sample/image_list_number.txt"}  # 中央に標示する画像のリスト
BASE_MOVIE_PATH=${4:-"${PWD}/data/src/project/sample/main_part/base.mp4"}  # ベース動画

FADE_MOVIE_PATH=${PWD}/data/tmp/tmp/__image_fade.mov

# 必要なもの: 動画パート時間(10),フェードイン(4),フェードアウト(4),画像パス→
# 計算で求められるもの: フェードアウト開始(6 動画パート時間(10)-フェードアウト(4)), オーバーラップさせる時間(t,0,10 これまでオーバーラップされた時間(変数sumPartSec 動画パート時間の累積)と、それ+動画パート時間(10))

sumPartSec=0
n=1
# CSVファイルを1行ずつ読み込み、lib/fadeInOut.shと同じ処理
cat $CENTER_IMAGE_LIST_FILE_PATH | while IFS=',' read -r partSec fadeInSec fadeOutSec filePath; do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ -z "$partSec" || "$partSec" == \#* ]]; then
        continue
    fi

    # パート動画のファイルパス
    movie_part_file_path=${MOVIE_PART_DIR_PATH}part_$(printf "%04d" $n).mp4

    # 画像からフェード動画作成 背景は透明で、フェードイン、表示、フェードアウトする動画パーツ
    fadeOutStart=$((partSec - fadeOutSec))
    ffmpeg -y -loop 1 -i $filePath -vf "scale=1422:800,format=rgba,fade=t=in:st=0:d=${fadeInSec}:alpha=1,fade=t=out:st=${fadeOutStart}:d=${fadeOutSec}:alpha=1" -t ${partSec} -c:v qtrle $FADE_MOVIE_PATH < /dev/null
    
    # ベース動画とフェード動画から動画パート作成
    ffmpeg -y -i $BASE_MOVIE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,0,${partSec})'" -c:a copy $movie_part_file_path < /dev/null

    # 結合するファイル一覧にファイルパス追加
    echo "file '${movie_part_file_path}'" >> $MOVIE_PART_LIST_FILE_PATH
    
    # sumPartSecの更新
    sumPartSec=$((sumPartSec + partSec))

    # カウントアップ
    ((n++))
done

