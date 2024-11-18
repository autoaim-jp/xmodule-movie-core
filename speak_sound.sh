#!/bin/bash

DATA_DIR_PATH="${PWD}/data/"
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
CONCAT_SOUND_FILE_PATH=${DATA_DIR_PATH}generated/speak_sound/${CURRENT_TIME}.wav
SOUND_DIR=${DATA_DIR_PATH}generated/_common/speak_sound/

# input
NARRATION_FILE_PATH=${1:-"${DATA_DIR_PATH}src/project/sample/narration.csv"}

# tmp
WAV_LIST_FILE_PATH=${DATA_DIR_PATH}tmp/speak_sound/${CURRENT_TIME}_for_ffmpeg.txt

./core/voicepeak.sh $NARRATION_FILE_PATH $WAV_LIST_FILE_PATH $SOUND_DIR
if [[ $? -ne 0 ]]; then
  echo "異常終了しました。"
  exit 1
fi
echo "wav一覧ファイル: $WAV_LIST_FILE_PATH"
echo "wavファイルディレクトリ: $SOUND_DIR"

./core/concatWav.sh $WAV_LIST_FILE_PATH $CONCAT_SOUND_FILE_PATH
echo "結合結果のwavファイル: $CONCAT_SOUND_FILE_PATH"

