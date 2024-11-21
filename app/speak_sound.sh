#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# output
if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
  CONCAT_SOUND_FILE_PATH=${1}
else
  OUTPUT_DIR_PATH=${DATA_DIR_PATH}generated/speak_sound/ 
  mkdir -p $OUTPUT_DIR_PATH
  CONCAT_SOUND_FILE_PATH=${OUTPUT_DIR_PATH}${CURRENT_TIME}.wav
fi
SOUND_DIR_PATH=${DATA_DIR_PATH}generated/_common/speak_sound/
mkdir -p $SOUND_DIR_PATH
SUBTITLE_CSV_FILE_PATH=${2:-"${DATA_DIR_PATH}generated/subtitle.csv"}

# input
NARRATION_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}narration.csv"}

# tmp
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/speak_sound/ 
mkdir -p $TMP_DIR_PATH
WAV_LIST_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}_for_ffmpeg.txt

${ROOT_DIR_PATH}core/voicepeak.sh $WAV_LIST_FILE_PATH $SOUND_DIR_PATH $SUBTITLE_CSV_FILE_PATH $NARRATION_FILE_PATH
if [[ $? -ne 0 ]]; then
  echo "異常終了しました。"
  exit 1
fi
echo "wav一覧ファイル: $WAV_LIST_FILE_PATH"
echo "wavファイルディレクトリ: $SOUND_DIR_PATH"

${ROOT_DIR_PATH}core/concatWav.sh $CONCAT_SOUND_FILE_PATH $WAV_LIST_FILE_PATH
echo "結合結果のwavファイル: $CONCAT_SOUND_FILE_PATH"

