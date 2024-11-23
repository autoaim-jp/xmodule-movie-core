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
IMAGE_LIST_FILE_PATH=${3:-"${DATA_DIR_PATH}generated/image_list.csv"}

# input
NARRATION_FILE_PATH=${4:-"${SAMPLE_PROJECT_DIR_PATH}narration.csv"}
IMAGE_DIR_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}image_list_number/"}
VOICE_ENGINE=${6:-"voicevox"}

# tmp
TMP_DIR_PATH=${DATA_DIR_PATH}tmp/speak_sound/ 
mkdir -p $TMP_DIR_PATH
WAV_LIST_FILE_PATH=${TMP_DIR_PATH}${CURRENT_TIME}_for_ffmpeg.txt

if [[ "$VOICE_ENGINE" == "voicepeak" ]]; then
  ${ROOT_DIR_PATH}core/voicepeak.sh $WAV_LIST_FILE_PATH $SOUND_DIR_PATH $SUBTITLE_CSV_FILE_PATH $IMAGE_LIST_FILE_PATH $NARRATION_FILE_PATH $IMAGE_DIR_PATH
  if [[ $? -ne 0 ]]; then
    echo "異常終了しました。"
    exit 1
  fi
elif [[ "$VOICE_ENGINE" == "voicevox" ]]; then
  ${ROOT_DIR_PATH}core/voicevox.sh $WAV_LIST_FILE_PATH $SOUND_DIR_PATH $SUBTITLE_CSV_FILE_PATH $IMAGE_LIST_FILE_PATH $NARRATION_FILE_PATH $IMAGE_DIR_PATH
  if [[ $? -ne 0 ]]; then
    echo "異常終了しました。"
    exit 1
  fi
else
  echo "不正なVOICE_ENGINEです。想定: voicepeak or voicevox, 実態: ${VOICE_ENGINE}"
  exit 1
fi

echo "wav一覧ファイル: $WAV_LIST_FILE_PATH"
echo "wavファイルディレクトリ: $SOUND_DIR_PATH"

${ROOT_DIR_PATH}core/concatWav.sh $CONCAT_SOUND_FILE_PATH $WAV_LIST_FILE_PATH
echo "結合結果のwavファイル: $CONCAT_SOUND_FILE_PATH"

