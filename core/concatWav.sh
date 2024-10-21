#!/bin/bash

WAV_LIST_FILE_PATH=${1:-"${PWD}/data/src/project/sample/wav_list_for_ffmpeg.txt"}
CONCAT_SOUND_FILE_PATH=${2:-/tmp/concat.wav}

# テキストファイル内のwavファイルを順に結合
# なぜか早口になってしまう
# ffmpeg -f concat -safe 0 -i $WAV_LIST_FILE_PATH -c copy $CONCAT_SOUND_FILE_PATH > /dev/null 2>&1
sox $(<$WAV_LIST_FILE_PATH) $CONCAT_SOUND_FILE_PATH

# 結合したwavファイルの長さを表示
echo "結合したwavファイルの長さ: $(soxi -d $CONCAT_SOUND_FILE_PATH) または $(soxi -D $CONCAT_SOUND_FILE_PATH) 秒"
