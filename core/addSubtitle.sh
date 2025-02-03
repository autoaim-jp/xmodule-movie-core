#!/bin/bash

SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../asset/src/project/sample/
TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/

# output
SUBTITLE_MOVIE_FILE_PATH=${1:-/tmp/subtitle.mp4}

# input
CONCAT_MOVIE_FILE_PATH=${2:-"${SAMPLE_PROJECT_DIR_PATH}concat_movie.mp4"}
SUBTITLE_TEXT_FILE_PATH=${3:-"${SAMPLE_PROJECT_DIR_PATH}subtitle.csv"}
FONT_FILE_PATH=${4:-"${SCRIPT_DIR_PATH}../asset/SourceHanSans-Bold.otf"}
SUBTITLE_MODE=${5:-"bottom"}

# tmp
TEXT_FILE_DIR_PATH=${TMP_DIR_PATH}subtitle_text/
mkdir -p $TEXT_FILE_DIR_PATH

# 字幕ファイルを1行ずつ読み込んで字幕フィルタを作成
filter_text=""
n=1
while IFS=',' read -r start end _text; do
  # 空行と#から始まるコメント行は無視
  if [[ -z "$start" || "$start" == \#* ]]; then
    continue
  fi

  # 半角スペースは処理できないので、全角スペースに変換
  text="${_text// /　}"

  # 一時ファイルに書き込み。改行コードを正しく処理するため。
  text_file_path=${TEXT_FILE_DIR_PATH}${n}.txt
  echo -e "$text" | python3 -c "
import sys
input_text = sys.stdin.read().strip()
n = 40
print('\n'.join([input_text[i:i+n] for i in range(0, len(input_text), n)]))
"> "$text_file_path"
 
  # 字幕設定
  if [[ "$SUBTITLE_MODE" == "bottom" ]]; then
    filter_text="${filter_text}drawtext=textfile='${text_file_path}':fontfile=${FONT_FILE_PATH}:fontcolor=white:boxborderw=10:box=1:boxcolor=0x333333@0.8:fontsize=36:x=(w-text_w)/2:y=h-100:enable='between(t,${start},${end})',"
  elif [[ "$SUBTITLE_MODE" == "top" ]]; then
    filter_text="${filter_text}drawtext=textfile='${text_file_path}':fontfile=${FONT_FILE_PATH}:fontcolor=white:boxborderw=10:box=1:boxcolor=0x575757@0.7:fontsize=36:x=(w-text_w)/2:y=40:enable='between(t,${start},${end})',"
  fi

  # カウントアップ
  ((n++))
done < $SUBTITLE_TEXT_FILE_PATH

# 最後のカンマを消す
# filter_text=${filter_text:0:-1}
filter_text="${filter_text}format=yuv420p"

# 字幕を動画につける
ffmpeg -y -i $CONCAT_MOVIE_FILE_PATH -vf $filter_text -r 60 -s 1920x1080 -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast -c:a copy $SUBTITLE_MOVIE_FILE_PATH

# 一時ディレクトリを削除する
rm -rf $TEXT_FILE_DIR_PATH

