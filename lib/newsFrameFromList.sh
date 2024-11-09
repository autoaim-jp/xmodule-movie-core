#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__newsFrame_${CURRENT_TIME}/
background_image=${PWD}/data/src/project/sample/asset/background.jpg    # 全画面の背景画像
center_image=${PWD}/data/src/project/sample/asset/graph.png        # 中央に表示する画像
subtitle_text="字幕の文章"           # 中央下に表示する文章
bottom_left_image=${PWD}/data/src/project/sample/asset/woman_flop.png    # 左下に表示する画像
csv_file=${PWD}/data/src/project/sample/image_list_number.txt

right_top_image=${TMP_DIR}right_top.png
FADE_MOVIE_PATH=${TMP_DIR}image_fade.mov
OUTPUT_MOVIE_PATH=${TMP_DIR}output.mp4
BASE_MOVIE_PATH=${TMP_DIR}base.mp4

mkdir -p $TMP_DIR

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
# 右上の画像作成
convert -size 200x80 xc:none \
    -fill "#f16529" -draw "roundrectangle 0,0 200,80 15,15" \
    -gravity center \
    -font "/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf" \
    -pointsize 20 -fill white -annotate 0 "研修くん" \
    $right_top_image


# sumPartSecの初期値を設定
sumPartSec=0

# sumPartSecの最終の値を確認
while IFS=',' read -r partSec fadeInSec fadeOutSec filePath
do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ "$partSec" =~ ^#.* ]] || [[ -z "$partSec" ]]; then
        continue
    fi
    # sumPartSecの更新
    sumPartSec=$((sumPartSec + partSec))
done < "$csv_file"

echo $sumPartSec

# FFmpegコマンド
# 右上に画像配置
ffmpeg -y -i "$background_image" -i "$bottom_left_image" -i "$right_top_image" \
-filter_complex "\
    [0:v]scale=${output_width}:${output_height}[bg]; \
    [2:v]scale=200:80[scaled_right_top_image]; \
    [bg][scaled_right_top_image]overlay=x=W-w-10:y=20[bg_with_right_top_image]; \
    [1:v]scale=${left_bottom_image_width}:${left_bottom_image_height}[bottom_left_img]; \
    [bg_with_right_top_image][bottom_left_img]overlay=x=20:y=H-${left_bottom_image_height}-20" \
-c:v libx264 -t $sumPartSec -pix_fmt yuv420p $BASE_MOVIE_PATH

# 必要なもの: 動画パート時間(10),フェードイン(4),フェードアウト(4),画像パス→
# 計算で求められるもの: フェードアウト開始(6 動画パート時間(10)-フェードアウト(4)), オーバーラップさせる時間(t,0,10 これまでオーバーラップされた時間(変数sumPartSec 動画パート時間の累積)と、それ+動画パート時間(10))

# sumPartSecを再度初期化
sumPartSec=0
# CSVファイルを1行ずつ読み込む
cat $csv_file | while read -r line; do
    partSec=$(echo "$line" | awk -F',' '{print $1}' | xargs)
    fadeInSec=$(echo "$line" | awk -F',' '{print $2}' | xargs)
    fadeOutSec=$(echo "$line" | awk -F',' '{print $3}' | xargs)
    filePath=$(echo "$line" | awk -F',' '{print $4}' | xargs)
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ -z "$partSec" || "$partSec" == \#* ]]; then
        continue
    fi

    # 結果の表示
    echo "==================================================="
    echo "$partSec,$fadeInSec,$fadeOutSec,$filePath"
    echo "==================================================="
    # 背景が透明で、フェードイン、フェードアウトの動画パーツ
    fadeOutStart=$((partSec - fadeOutSec))
    ffmpeg -y -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=${fadeInSec}:alpha=1,fade=t=out:st=${fadeOutStart}:d=4:alpha=1" -t 10 -c:v qtrle $FADE_MOVIE_PATH 2>/dev/null < /dev/null
    #ffmpeg -y -loop 1 -i $center_image -vf "scale=1200:800,format=rgba,fade=t=in:st=0:d=${fadeInSec}:alpha=1,fade=t=out:st=${fadeOutStart}:d=4:alpha=1" -t 10 -c:v qtrle $FADE_MOVIE_PATH 2>/dev/null
    
    # lib/fadeInOut.shと同じ
    # 別動画の中央にフェードイン・アウトの動画をオーバーラップさせる
    nextSumPartSec=$((sumPartSec + partSec))
    ffmpeg -y -i $BASE_MOVIE_PATH -i $FADE_MOVIE_PATH -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable='between(t,${sumPartSec},${nextSumPartSec})'" -c:a copy $OUTPUT_MOVIE_PATH 2>/dev/null < /dev/null

    # sumPartSecの更新
    sumPartSec=$((sumPartSec + partSec))
done

echo $TMP_DIR
xdg-open $TMP_DIR

