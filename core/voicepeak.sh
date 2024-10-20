#!/bin/bash

# CSVファイル名
NARRATION_FILE_PATH=${1:-"${PWD}/data/src/sample/narration.csv"}
WAV_LIST_FILE_PATH=${2:-/tmp/wav_list_for_ffmpeg.txt}
SOUND_DIR=${3:-/tmp/sound/}
LINE_NUMBER=0


#
declare -A NARRATOR_LIST=(
  [fc]="Japanese Female Child"
  [m1]="Japanese Male 1"
  [m2]="Japanese Male 2"
  [m3]="Japanese Male 3"
  [f1]="Japanese Female 1"
  [f2]="Japanese Female 2"
  [f3]="Japanese Female 3"
)

# サウンドディレクトリを作成
mkdir -p $SOUND_DIR

# CSVファイルを行ごとに処理
cat $NARRATION_FILE_PATH | while IFS=',' read -r type arg1 arg2 arg3 arg4; do
  # 空行と#から始まるコメント行は無視
  if [[ -z "$type" || "$type" == \#* ]]; then
    continue
  fi

  # 行数をインクリメント
  ((LINE_NUMBER++))
  case $type in
    speak)
      OUTPUT_FILE=$(printf "%s%03d_%s.wav" $SOUND_DIR "$LINE_NUMBER" "$arg4")
      OUTPUT_FILE=$(printf "%s%03d_.wav" $SOUND_DIR "$LINE_NUMBER")
      _NARRATOR=$arg1
      if [[ -n "${NARRATOR_LIST[$_NARRATOR]}" ]]; then
          NARRATOR=${NARRATOR_LIST[$_NARRATOR]}
      else
          echo "未対応のナレーター: $_NARRATOR"
	  exit 1
      fi
      SPEED=$arg2
      EMOTION_EXPR=$arg3
      TEXT=$arg4
      sleep 1
      ~/application/Voicepeak/voicepeak -o $OUTPUT_FILE -n "$NARRATOR" --speed $SPEED -e "$EMOTION_EXPR" -s "$TEXT" 2>/dev/null
      if [[ $? -eq 0 ]]; then
        echo "音声ファイルの作成に成功。"
        echo "file '$OUTPUT_FILE'" >> $WAV_LIST_FILE_PATH
      else
        echo "音声ファイルの作成に失敗しました。再度生成します。"
	echo $type,$arg1,$arg2,$arg3,$arg4
	sleep 3
        ~/application/Voicepeak/voicepeak -o $OUTPUT_FILE -n "$NARRATOR" --speed $SPEED -e "$EMOTION_EXPR" -s "$TEXT"
        if [[ $? -ne 0 ]]; then
          echo "音声ファイルの作成に失敗しました。終了します。"
	  exit 1
	fi
      fi
      ;;

    silent)
      SILENT_TIME_S=$arg1
      OUTPUT_FILE=$(printf "%s%03d_silent_%ds.wav" $SOUND_DIR "$LINE_NUMBER" "$SILENT_TIME_S")
      #ffmpeg -f f32le -ar 48000 -ac 1 -i /dev/zero -t $SILENT_TIME_S $OUTPUT_FILE || true
      sox -n -r 48000 -c 1 $OUTPUT_FILE trim 0 $SILENT_TIME_S
      echo "file '$OUTPUT_FILE'" >> $WAV_LIST_FILE_PATH
      ;;

    *)
      echo "未対応のtype: $type $arg1 $arg2 $arg3 $arg4"
      # exit 1
      ;;
   esac
done

