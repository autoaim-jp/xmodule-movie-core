#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
WAV_LIST_FILE_PATH=${1:-/tmp/wav_list_for_ffmpeg.txt}
SOUND_DIR=${2:-/tmp/sound/}
mkdir -p $SOUND_DIR

# input
NARRATION_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}narration.csv"}

# other
LINE_NUMBER=0

# ナレーターの変換用
declare -A NARRATOR_LIST=(
  [fc]="Japanese Female Child"
  [m1]="Japanese Male 1"
  [m2]="Japanese Male 2"
  [m3]="Japanese Male 3"
  [f1]="Japanese Female 1"
  [f2]="Japanese Female 2"
  [f3]="Japanese Female 3"
)

# 音声ファイルを作成
function _speak() {
  sleep 1
  OUTPUT_FILE_PATH=$1
  _NARRATOR=$2
  SPEED=$3
  EMOTION_EXPR=$4
  TEXT=$5
  echo $OUTPUT_FILE_PATH
  if [[ -n "${NARRATOR_LIST[$_NARRATOR]}" ]]; then
      NARRATOR=${NARRATOR_LIST[$_NARRATOR]}
  else
      echo "未対応のナレーター: $_NARRATOR"
	  exit 1
  fi

  ~/application/Voicepeak/voicepeak -o $OUTPUT_FILE_PATH -n "$NARRATOR" --speed $SPEED -e "$EMOTION_EXPR" -s "$TEXT" 2>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "音声ファイルの作成に成功。"
    return 0
  else
    echo "音声ファイルの作成に失敗しました。再度生成します。"
    echo "$OUTPUT_FILE_PATH,$_NARRATOR,$NARRATOR,$SPEED,$EMOTION_EXPR,$TEXT"
    sleep 3
    ~/application/Voicepeak/voicepeak -o $OUTPUT_FILE_PATH -n "$NARRATOR" --speed $SPEED -e "$EMOTION_EXPR" -s "$TEXT" 2>/dev/null
    if [[ $? -ne 0 ]]; then
      echo "音声ファイルの作成に失敗しました。終了します。"
      return 1
    fi
    return 0
  fi
}

# CSVファイルを行ごとに処理
cat $NARRATION_FILE_PATH | while IFS=',' read -r type arg1 arg2 arg3 arg4; do
  # 空行と#から始まるコメント行は無視
  if [[ -z "$type" || "$type" == \#* ]]; then
    continue
  fi

  # 行数をインクリメント
  ((LINE_NUMBER++))
  # 音声ファイル名 すでに存在していれば利用 なければ作成 ファイル名を安全にするためシェルの特殊文字とスラッシュをアンダースコアで置換
  OUTPUT_FILE_NAME=$(printf "%s_%s_%s_%s_%s.wav" "$type" "$arg1" "$arg2" "$arg3" "$arg4" | sed 's/[*?[\]{}()&|;<>`"'"'"'\\$#\/]/_/g')
  OUTPUT_FILE_PATH="${SOUND_DIR}${OUTPUT_FILE_NAME}"

  # 音声ファイルがなければ作成
  if [[ ! -f $OUTPUT_FILE_PATH ]]; then
    if [[ $type == "speak" ]]; then
      _speak $OUTPUT_FILE_PATH $arg1 $arg2 $arg3 $arg4
    elif [[ $type == "silent" ]]; then
      SILENT_TIME_S=$arg1
      sox -n -r 48000 -c 1 $OUTPUT_FILE_PATH trim 0 $SILENT_TIME_S >/dev/null 2>&1
    else
      echo "未対応のtype: $type $arg1 $arg2 $arg3 $arg4"
      exit 1
    fi
  
    # 音声ファイルが生成できなければ異常終了
    if [[ ! -f $OUTPUT_FILE_PATH ]]; then
      exit 1
    fi
  fi

  # 音声ファイルをwavリストに追記
  echo "$OUTPUT_FILE_PATH" >> $WAV_LIST_FILE_PATH
  # ffmpeg用
  # echo "file '$OUTPUT_FILE_PATH'" >> $WAV_LIST_FILE_PATH

  # 音声ファイルの長さを表示
  echo $(soxi -D $OUTPUT_FILE_PATH) $OUTPUT_FILE_PATH
done

