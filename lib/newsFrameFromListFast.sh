#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR="/tmp/__newsFrame_${CURRENT_TIME}/"
background_image=${1:-"${PWD}/data/src/project/sample/asset/background.jpg"}    # 全画面の背景画像
subtitle_text=${2:-"字幕の文章"}           # 中央下に表示する文章
bottom_left_image=${3:-"${PWD}/data/src/project/sample/asset/woman_flop.png"}    # 左下に表示する画像
CENTER_IMAGE_LIST_FILE_PATH=${4:-"${PWD}/data/src/project/sample/image_list_number.txt"}  # 中央に標示する画像のリスト

right_top_image=${TMP_DIR}right_top.png
right_bottom_image=${TMP_DIR}right_bottom.png
right_bottom_image_tmp1=${TMP_DIR}right_bottom_tmp1.png
right_bottom_image_tmp2=${TMP_DIR}right_bottom_tmp2.png
left_top_image=${TMP_DIR}left_top.png
FADE_MOVIE_PATH=${TMP_DIR}image_fade.mov
OUTPUT_MOVIE_PATH=${TMP_DIR}output.mp4
BASE_MOVIE_PATH=${TMP_DIR}base.mp4
MOVIE_PART_DIR_PATH=${TMP_DIR}part/
MOVIE_PART_LIST_FILE_PATH=${TMP_DIR}part_list.txt

mkdir -p $TMP_DIR
mkdir -p $MOVIE_PART_DIR_PATH

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
    -pointsize 40 -fill white -annotate 0 "研修くん" \
    $right_top_image

# 右下の画像作成
# まずは黒縁取り画像作成
convert -size 380x100 xc:none -font /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf -pointsize 36 \
    -fill black -stroke black -strokewidth 7 -gravity center \
    -annotate 0 "このアプリの使い方" $right_bottom_image_tmp1

# 次に白い中の文字作成
convert -size 380x100 xc:none -font /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf -pointsize 36 \
    -fill white -gravity center \
    -annotate 0 "このアプリの使い方" $right_bottom_image_tmp2
# 画像を重ねる
convert $right_bottom_image_tmp1 $right_bottom_image_tmp2 -gravity center -composite $right_bottom_image

# 左上の画像作成
convert -size 655x100 xc:none \
    -fill '#ebebeb' -stroke '#f16529' -strokewidth 2 \
    -draw "polygon 10,25 600,25 650,50 600,75 10,75" \
    -fill '#f16529' -stroke black -strokewidth 3 \
    -draw "polyline 5,70 20,40 35,60 50,30 65,50 80,15" \
    -font /usr/share/fonts/opentype/source-han-sans/SourceHanSans-Bold.otf -pointsize 38 \
    -stroke black -fill '#f16529' -strokewidth 2 \
    -draw "text 120,65 '株式グラフ管理Webアプリ'" \
    $left_top_image


# totalPartSecの初期値を設定
totalPartSec=0

# totalPartSecの最終の値を確認
while IFS=',' read -r partSec fadeInSec fadeOutSec filePath
do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ "$partSec" =~ ^#.* ]] || [[ -z "$partSec" ]]; then
        continue
    fi
    # totalPartSecの更新
    totalPartSec=$((totalPartSec + partSec))
done < "$CENTER_IMAGE_LIST_FILE_PATH"

echo $totalPartSec

# ベース動画作成　BG画像表示。四隅に画像配置
ffmpeg -y -i "$background_image" -i "$bottom_left_image" -i "$right_top_image" -i "$right_bottom_image" -i "$left_top_image" \
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
-c:v libx264 -t $totalPartSec -pix_fmt yuv420p $BASE_MOVIE_PATH

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
    echo "==================================================="

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
    echo "==================================================="
done

# 結合ファイル一覧から結合動画作成
ffmpeg -f concat -safe 0 -i $MOVIE_PART_LIST_FILE_PATH -c:a copy $OUTPUT_MOVIE_PATH < /dev/null

echo $TMP_DIR
xdg-open $TMP_DIR

