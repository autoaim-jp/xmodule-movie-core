#!/bin/bash

WAV_LIST_FILE_PATH=${1:-"${PWD}/data/src/sample/wav_list_for_ffmpeg.txt"}
CONCAT_SOUND_FILE_PATH=${2:-/tmp/concat.wav}

# テキストファイル内のwavファイルを順に結合
ffmpeg -f concat -safe 0 -i $WAV_LIST_FILE_PATH -c copy $CONCAT_SOUND_FILE_PATH

