#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
CONCAT_SOUND_FILE_PATH=${1:-/tmp/concat.wav}

# input
WAV_LIST_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}wav_list_for_ffmpeg.txt"}

# テキストファイル内のwavファイルを順に結合
# wavファイルをffmpegで結合(なぜか早口になってしまう)
# ffmpeg -f concat -safe 0 -i $WAV_LIST_FILE_PATH -c copy $CONCAT_SOUND_FILE_PATH > /dev/null 2>&1
# wavファイルをsoxで結合
sox $(<$WAV_LIST_FILE_PATH) $CONCAT_SOUND_FILE_PATH

# 結合したwavファイルの長さを表示
echo "結合したwavファイルの長さ: $(soxi -d $CONCAT_SOUND_FILE_PATH) または $(soxi -D $CONCAT_SOUND_FILE_PATH) 秒"

