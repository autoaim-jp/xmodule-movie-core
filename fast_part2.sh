#!/bin/bash

# init
set -euo pipefail # エラー発生時は即座に終了
# set -x # 実行コマンドをデバッグ用に表示
cd "$(dirname "$0")" # 作業ディレクトリを移動作業ディレクトリを移動
SCRIPT_NAME="$(basename "${0}")" # ログ出力時に使用するスクリプト名
echo "${SCRIPT_NAME}: start"

# lib
debug_log() {
  if [ "${DEBUG:-false}" = "true" ]; then
    echo "${SCRIPT_NAME}<debug>: ${1}"
  fi
}
check_command_available() {
  for cmd in "$@"; do
    command -v "${cmd}" >/dev/null 2>&1 || { echo "${SCRIPT_NAME}: ${cmd} is required"; exit 1; } # 必要なコマンドがなければ終了
  done
}

# init2
# check_command_available "jq" "curl" # 必要なコマンドがあるかどうかあらかじめ確認
debug_log "start" # デバッグモードがオンになっているかどうかがここでわかる

# constant
ROOT_DIR_PATH=${PWD}/
FAST_DATA_DIR_PATH="${ROOT_DIR_PATH}data/fast/"
mkdir -p ${FAST_DATA_DIR_PATH} # ディレクトリはここで作成しておく
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
FONT_FILE_PATH="${ROOT_DIR_PATH}asset/SourceHanSans-Bold.otf"
SUBTITLE_MODE="bottom"

# output
OUTPUT_MOVIE_FILE_PATH=${1:-"${FAST_DATA_DIR_PATH}${CURRENT_TIME}.mp4"}

# input
TMP_SOUND_FILE_PATH="${2:-/tmp/__speak_sound.wav}"
TMP_SUBTITLE_FILE_PATH="${3:-/tmp/__subtitle.csv}"
TMP_IMAGE_LIST_FILE_PATH="${4:-/tmp/__image_list.csv}"
IMAGE_DIR_PATH=${5} # 挿絵画像のディレクトリ
TITLE_TEXT=${6} # 動画のタイトル
TITLE_IMAGE_FILE_PATH=${7} # 動画の表紙画像
TITLE_MOVIE_SEC=${8} # タイトル画面の秒数
TELOP_IMAGE_FILE_PATH=${9} # 右上のテロップ画像
ENDING_FILE_INDEX=${10:--1} # エンデイングファイルの指定

# tmp
TMP_DIR_PATH="$(mktemp -p ${FAST_DATA_DIR_PATH} -d)/"
echo "${SCRIPT_NAME}: TMP_DIR_PATH: $TMP_DIR_PATH"
TMP_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_movie.mp4"
TMP_MAIN_PART_MOVIE_FILE_PATH="${TMP_DIR_PATH}main.mp4"
TMP_MOVIE_PART_LIST_FILE_PATH="${TMP_DIR_PATH}part_list.txt"
MOVIE_PART_DIR_PATH="${TMP_DIR_PATH}movie_part/"
mkdir -p $MOVIE_PART_DIR_PATH

cleanup() {
  echo "${SCRIPT_NAME}: Cleaning up temporary files..."
  # echo "消さない $TMP_DIR_PATH"
  # google-chrome $TMP_DIR_PATH
  rm -rf "$TMP_DIR_PATH"
}

# スクリプト終了時・異常終了時に cleanup を実行
trap cleanup EXIT INT TERM


# タイトル画像作成
# フェードインとフェードアウトの動画
${ROOT_DIR_PATH}app/title_movie.sh "$TMP_TITLE_MOVIE_FILE_PATH" "$TITLE_TEXT" "$TITLE_IMAGE_FILE_PATH" $TITLE_MOVIE_SEC "$FONT_FILE_PATH"

# 結合ファイル一覧に、タイトルのファイルパスを記載
echo > $TMP_MOVIE_PART_LIST_FILE_PATH
echo "file '$(realpath ${TMP_TITLE_MOVIE_FILE_PATH})'" >> $TMP_MOVIE_PART_LIST_FILE_PATH

# フェード動画作成してマージ
CENTER_BACKGROUND_IMAGE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/children_book_1/bg_004896_1024.png" # 中央画像の背景画像パス
# スライドではなくタイトルと同じフェードにする
# ${ROOT_DIR_PATH}core/mergeBaseAndFadeMovie.sh $TMP_MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $TMP_IMAGE_LIST_FILE_PATH $BASE_MOVIE_FILE_PATH $CENTER_BACKGROUND_IMAGE_FILE_PATH

# スライドではなくタイトルと同じフェードにする mergeBaseAndFadeMovie.shとfadeEffect.shを参考に作成
BACKGROUND_IMAGE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/children_book_1/bg_004896.png" # 背景画像パス
CENTER_BACKGROUND_IMAGE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/children_book_1/bg_square_004896.png" # 背景画像パス

n=1
declare -a pids
# `cat` を使わず、`while` ループを `< ファイル` の形で実行する
while IFS=',' read -r part_sec fade_in_sec fade_out_sec file_path; do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ -z "$part_sec" || "$part_sec" == \#* ]]; then
        continue
    fi

    # パート動画のファイルパス 絶対パス
    movie_part_file_path=$(realpath ${MOVIE_PART_DIR_PATH}part_$(printf "%04d" $n).mp4)

    FADE_OUT_START=$(expr $part_sec \* 60 - 90)

    ffmpeg -y -i "$BACKGROUND_IMAGE_FILE_PATH" -i "$TELOP_IMAGE_FILE_PATH" -loop 1 -framerate 60 -i "$file_path" \
      -filter_complex "\
          [0:v]scale=1920:1080[bg]; \
          [1:v]scale=380:100[lt]; \
          [2:v]scale=1024:1024,fade=in:0:30:alpha=1,fade=out:${FADE_OUT_START}:30:alpha=1,format=yuva420p[main]; \
          [bg][lt]overlay=x=W-w-10:y=20[bg_lt]; \
          [bg_lt][main]overlay=x=(1920-w)/2:y=(1080-h)/2[out]" \
      -map "[out]" -t "${part_sec}" \
      -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast "$movie_part_file_path" < /dev/null &

    # プロセスIDを格納
    pids+=($!)

    # 結合するファイル一覧にファイルパス追加
    echo "file '${movie_part_file_path}'" >> $TMP_MOVIE_PART_LIST_FILE_PATH

    # カウントアップ
    ((n++))
done < "$TMP_IMAGE_LIST_FILE_PATH"  # ★ cat を使わずに、ループの入力にファイルを指定することでサブシェルを回避

# すべてのバックグラウンドプロセスの終了を待つ
for pid in "${pids[@]}"; do
    wait "$pid"
done


ending_file_list=(
  "0520_reencoded.mp4"
  "0520_reverse_reencoded.mp4"
  "0729_reencoded.mp4"
  "0729_reverse_reencoded.mp4"
  "0730_reencoded.mp4"
  "0730_reverse_reencoded.mp4"
)

# ランダムに1つ選択
if [[ $ENDING_FILE_INDEX -ge 0 && $ENDING_FILE_INDEX -lt ${#ending_file_list[@]} ]]; then
  random_index=$ENDING_FILE_INDEX
else
  random_index=$((RANDOM % ${#ending_file_list[@]}))
fi
LOGO_ROTATE_MOVIE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/fast/${ending_file_list[$random_index]}"
# 結合ファイル一覧に、エンディング動画のファイルパスを記載
echo "file '$(realpath ${LOGO_ROTATE_MOVIE_FILE_PATH})'" >> $TMP_MOVIE_PART_LIST_FILE_PATH

# ファイル一覧から結合
# 以下はfastConcat.shにより不要
# ffmpeg -y -f concat -safe 0 -i "$TMP_MOVIE_PART_LIST_FILE_PATH" -i "$TMP_SOUND_FILE_PATH" -c:v h264_nvenc -c:a aac -strict experimental "$TMP_MAIN_PART_MOVIE_FILE_PATH"

${ROOT_DIR_PATH}core/fastConcat.sh $OUTPUT_MOVIE_FILE_PATH $TMP_SUBTITLE_FILE_PATH $FONT_FILE_PATH $SUBTITLE_MODE $TMP_MOVIE_PART_LIST_FILE_PATH $TMP_SOUND_FILE_PATH

# google-chrome "$OUTPUT_MOVIE_FILE_PATH"

echo "${SCRIPT_NAME}: complete."

