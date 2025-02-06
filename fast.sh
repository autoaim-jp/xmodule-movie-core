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
IMAGE_DIR_PATH=${2} # 挿絵画像のディレクトリ
NARRATION_FILE_PATH=${3} # narration.csv
VOICE_ENGINE=${4} # voicepeak, voicevox, openai or aivisspeech
TITLE_TEXT=${5} # 動画のタイトル
TITLE_IMAGE_FILE_PATH=${6} # 動画の表紙画像
TITLE_MOVIE_SEC=${7} # タイトル画面の秒数
TELOP_IMAGE_FILE_PATH=${8} # 右上のテロップ画像


# tmp
TMP_DIR_PATH="$(mktemp -p ${FAST_DATA_DIR_PATH} -d)/"
echo "${SCRIPT_NAME}: TMP_DIR_PATH: $TMP_DIR_PATH"
TMP_SOUND_FILE_PATH="${TMP_DIR_PATH}__speak_sound.wav"
TMP_SUBTITLE_FILE_PATH="${TMP_DIR_PATH}__subtitle.csv"
TMP_IMAGE_LIST_FILE_PATH="${TMP_DIR_PATH}__image_list.csv"
TMP_TITLE_MOVIE_FILE_PATH="${TMP_DIR_PATH}__title_movie.mp4"
TMP_MAIN_PART_MOVIE_FILE_PATH="${TMP_DIR_PATH}main.mp4"
TMP_MOVIE_PART_LIST_FILE_PATH="${TMP_DIR_PATH}part_list.txt"
MOVIE_PART_DIR_PATH="${TMP_DIR_PATH}movie_part/"
mkdir -p $MOVIE_PART_DIR_PATH
#echo "デバッグ 毎回同じもの作らなくていい"
#TMP_MOVIE_PART_LIST_FILE_PATH="./__part_list.txt"
#MOVIE_PART_DIR_PATH="./__movie_part/"
#TMP_TITLE_MOVIE_FILE_PATH="./__tmp_title_movie.mp4"

cleanup() {
  echo "${SCRIPT_NAME}: Cleaning up temporary files..."
  echo "消さない $TMP_DIR_PATH"
  # google-chrome $TMP_DIR_PATH
  # rm -rf "$TMP_DIR_PATH"
}

# スクリプト終了時・異常終了時に cleanup を実行
trap cleanup EXIT INT TERM

# 音声単体ファイル作成
# 音声ファイル結合
${ROOT_DIR_PATH}app/speak_sound.sh "$TMP_SOUND_FILE_PATH" "$TMP_SUBTITLE_FILE_PATH" "$TMP_IMAGE_LIST_FILE_PATH" "$NARRATION_FILE_PATH" "$IMAGE_DIR_PATH" "$VOICE_ENGINE"


# タイトル画像作成
# フェードインとフェードアウトの動画
${ROOT_DIR_PATH}app/title_movie.sh "$TMP_TITLE_MOVIE_FILE_PATH" "$TITLE_TEXT" "$TITLE_IMAGE_FILE_PATH" $TITLE_MOVIE_SEC "$FONT_FILE_PATH"

# 結合ファイル一覧に、タイトルのファイルパスを記載
echo > $TMP_MOVIE_PART_LIST_FILE_PATH
echo "file '$(realpath ${TMP_TITLE_MOVIE_FILE_PATH})'" >> $TMP_MOVIE_PART_LIST_FILE_PATH

# ベース動画作成
BASE_MOVIE_FILE_PATH=./__base.mp4
BACKGROUND_IMAGE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/children_book_1/bg_004896.png" # 背景画像パス
output_width=1920                     # 出力動画の幅
output_height=1080                    # 出力動画の高さ
ffmpeg -y -i "$BACKGROUND_IMAGE_FILE_PATH" -i "$TELOP_IMAGE_FILE_PATH" \
  -filter_complex "\
      [0:v]scale=${output_width}:${output_height}[bg]; \
      [1:v]scale=380:100[lt]; \
      [bg][lt]overlay=x=W-w-10:y=20 \
      " \
  -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast $BASE_MOVIE_FILE_PATH

# フェード動画作成してマージ
CENTER_BACKGROUND_IMAGE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/children_book_1/bg_004896_1024.png" # 中央画像の背景画像パス
# スライドではなくタイトルと同じフェードにする
# ${ROOT_DIR_PATH}core/mergeBaseAndFadeMovie.sh $TMP_MOVIE_PART_LIST_FILE_PATH $MOVIE_PART_DIR_PATH $TMP_IMAGE_LIST_FILE_PATH $BASE_MOVIE_FILE_PATH $CENTER_BACKGROUND_IMAGE_FILE_PATH

# スライドではなくタイトルと同じフェードにする
n=1
cat $TMP_IMAGE_LIST_FILE_PATH | while IFS=',' read -r part_sec fade_in_sec fade_out_sec file_path; do
    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ -z "$part_sec" || "$part_sec" == \#* ]]; then
        continue
    fi

    # パート動画のファイルパス 絶対パス
    movie_part_file_path=$(realpath ${MOVIE_PART_DIR_PATH}part_$(printf "%04d" $n).mp4)

    # fade_out_start=$((part_sec - fade_out_sec))
 
    ${ROOT_DIR_PATH}core/fadeEffect.sh $movie_part_file_path $file_path $part_sec
    # 結合するファイル一覧にファイルパス追加
    echo "file '${movie_part_file_path}'" >> $TMP_MOVIE_PART_LIST_FILE_PATH
    
    # カウントアップ
    ((n++))
done


# 結合ファイル一覧に、エンディング動画のファイルパスを記載
LOGO_ROTATE_MOVIE_FILE_PATH="${ROOT_DIR_PATH}asset/src/project/fast/0520_reencoded.mp4"
echo "file '$(realpath ${LOGO_ROTATE_MOVIE_FILE_PATH})'" >> $TMP_MOVIE_PART_LIST_FILE_PATH

cat $TMP_MOVIE_PART_LIST_FILE_PATH

# ファイル一覧から結合
# 以下はfastConcat.shにより不要
# ffmpeg -y -f concat -safe 0 -i "$TMP_MOVIE_PART_LIST_FILE_PATH" -i "$TMP_SOUND_FILE_PATH" -c:v h264_nvenc -c:a aac -strict experimental "$TMP_MAIN_PART_MOVIE_FILE_PATH"

${ROOT_DIR_PATH}core/fastConcat.sh $OUTPUT_MOVIE_FILE_PATH $TMP_SUBTITLE_FILE_PATH $FONT_FILE_PATH $SUBTITLE_MODE $TMP_MOVIE_PART_LIST_FILE_PATH $TMP_SOUND_FILE_PATH


google-chrome "$OUTPUT_MOVIE_FILE_PATH"

