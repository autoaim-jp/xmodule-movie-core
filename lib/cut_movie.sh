#!/bin/bash

# 引数を取得
OUTPUT_FILE=$1
INPUT_FILE=$2
START_TIME=$3
END_TIME=$4

# フェードイン・フェードアウトの長さ（秒）
FADE_DURATION=1

# 一時ファイル（フェード処理用）
TEMP_FILE="temp_output.mp4"

# 開始時間と終了時間の計算
DURATION=$(echo "$END_TIME - $START_TIME" | bc)

if (( $(echo "$DURATION < $FADE_DURATION * 2" | bc -l) )); then
  echo "Error: 動画の長さがフェード処理に必要な時間より短いです。"
  exit 1
fi

# 1. 動画の切り取り
ffmpeg -i "$INPUT_FILE" -ss "$START_TIME" -to "$END_TIME" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast "$TEMP_FILE"

# 2. フェードイン・フェードアウトの適用
ffmpeg -i "$TEMP_FILE" \
  -vf "fade=t=in:st=0:d=$FADE_DURATION,fade=t=out:st=$(echo "$DURATION - $FADE_DURATION" | bc):d=$FADE_DURATION" \
  -af "afade=t=in:st=0:d=$FADE_DURATION,afade=t=out:st=$(echo "$DURATION - $FADE_DURATION" | bc):d=$FADE_DURATION" \
   -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast "$OUTPUT_FILE"

# 一時ファイルを削除
rm "$TEMP_FILE"

echo "処理が完了しました: $OUTPUT_FILE"

