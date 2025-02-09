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

# output
TMP_SOUND_FILE_PATH="${1:-/tmp/__speak_sound.wav}"
TMP_SUBTITLE_FILE_PATH="${2:-/tmp/__subtitle.csv}"
TMP_IMAGE_LIST_FILE_PATH="${3:-/tmp/__image_list.csv}"

# input
IMAGE_DIR_PATH=${4} # 挿絵画像のディレクトリ
NARRATION_FILE_PATH=${5} # narration.csv
VOICE_ENGINE=${6} # voicepeak, voicevox, openai or aivisspeech

# 音声単体ファイル作成
# 音声ファイル結合
${ROOT_DIR_PATH}app/speak_sound.sh "$TMP_SOUND_FILE_PATH" "$TMP_SUBTITLE_FILE_PATH" "$TMP_IMAGE_LIST_FILE_PATH" "$NARRATION_FILE_PATH" "$IMAGE_DIR_PATH" "$VOICE_ENGINE"

echo "${SCRIPT_NAME}: complete."

