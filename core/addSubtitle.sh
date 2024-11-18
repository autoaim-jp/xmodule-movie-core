#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
SUBTITLE_MOVIE_FILE_PATH=${1:-/tmp/subtitle.mp4}

# input
CAPTURE_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}capture.mp4"}
SUBTITLE_TEXT_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}subtitle.csv"}

# 字幕ファイルを1行ずつ読み込んで字幕フィルタを作成
FILTER_TEXT=""
while IFS=',' read -r start end _text; do
  # 空行と#から始まるコメント行は無視
  if [[ -z "$start" || "$start" == \#* ]]; then
    continue
  fi

  # 半角スペースは処理できないので、全角スペースに変換
  EMOTION_EXPR="${text// /　}"
  # 字幕設定
  FILTER_TEXT="${FILTER_TEXT}drawtext=text='${text}':fontfile=/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf:fontcolor=white:boxborderw=10:box=1:boxcolor=0x333333@0.8:fontsize=24:x=(w-text_w)/2:y=h-50:enable='between(t,${start},${end})',"
done < $SUBTITLE_TEXT_FILE_PATH

# 最後のカンマを消す
FILTER_TEXT=${FILTER_TEXT:0:-1}

# 字幕を動画につける
ffmpeg -i $CAPTURE_MOVIE_FILE_PATH -vf $FILTER_TEXT $SUBTITLE_MOVIE_FILE_PATH

