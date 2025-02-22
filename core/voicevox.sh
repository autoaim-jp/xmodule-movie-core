#!/bin/bash

# <ルール整理>
# タイトルはsilent,1,,,とsilent,3,,,の行で挟む
# 各ページの最初はstart-page,,,,の行
# 文章は句点で行を分ける。その後、先頭にspeak,話し手ID,読み上げのスピード,感情,をつける。
# 話し手ID: 登場人物の中で1人目の女性ならf1、登場人物の中で2人目の男性ならm2のような規則
# 読み上げのスピード: 100が基本。早くするなら最大125。遅くするなら最低で75。
# 感情: happy=0が基本。最大は100。happyのほか、fun、angry、sadがある。アンダースコア_で区切り、happy=80_fun50のように複数指定できる。
# 各文章のあとはsilent,1,,,の行
# 各ページの最後はend-page,,,,の行、その後にsilent,3,,,の行


ENGINE_NAME=$(basename "$0" .sh)
SCRIPT_DIR_PATH=$(dirname "$0")/
SAMPLE_PROJECT_DIR_PATH=${SCRIPT_DIR_PATH}../data/src/project/sample/
##TMP_DIR_PATH=${SCRIPT_DIR_PATH}../data/tmp/tmp/
VOICEVOX_SERVER="http://voicevox:50021" # dockerならコンテナ名にvoicevoxを、ローカル実行なら/etc/hostsにvoicevox=127.0.0.2を指定

# output
WAV_LIST_FILE_PATH=${1:-/tmp/wav_list_for_ffmpeg.txt}
SOUND_DIR_PATH=${2:-/tmp/sound/}
mkdir -p $SOUND_DIR_PATH
SUBTITLE_CSV_FILE_PATH=${3:-/tmp/subtitle.csv}
# image_list.csv用ロジック
IMAGE_LIST_FILE_PATH=${4:-/tmp/image_list.csv}

# input
NARRATION_FILE_PATH=${5:-"${SAMPLE_PROJECT_DIR_PATH}narration.csv"}
# image_list.csv用ロジック
IMAGE_DIR_PATH=${6:-/tmp/image/}

# other
CSV_ENGINE_NAME=""

# ナレーターの変換用
declare -A NARRATOR_LIST=(
  [fc]="1" # ずんだもん
  [m1]="11" # 玄野武宏
  [m2]="12" # 青山龍星
  [m3]="13" # 剣崎雌雄
  [n]="2" # 四国めたん
  [f1]="4" # 四国めたん
  [f2]="1" # ずんだもん
  [f3]="7" # 春日部つむぎ
)

# 音声ファイルを作成
function _speak() {
  sleep 1
  output_file_path=$1
  _NARRATOR=$2
  SPEED=$3
  TEXT=$4
  echo $output_file_path
  if [[ -n "${NARRATOR_LIST[$_NARRATOR]}" ]]; then
    NARRATOR=${NARRATOR_LIST[$_NARRATOR]}
  else
    echo "未対応のナレーター: $_NARRATOR"
    exit 1
  fi

  curl -s -X POST "${VOICEVOX_SERVER}/audio_query?speaker=${NARRATOR}" \
       --get --data-urlencode text="${TEXT}" | \
  jq '.speedScale = '$SPEED | \
  jq '.intonation_scale = 1.4' | \
  jq '.outputSamplingRate = 48000' | \
  curl -s -X POST -H "Content-Type: application/json" \
       -d @- "${VOICEVOX_SERVER}/synthesis?speaker=${NARRATOR}" > $output_file_path
  
  if [[ $? -eq 0 ]]; then
    echo "音声ファイルの作成に成功。"
    return 0
  else
    echo "音声ファイルの作成に失敗しました。終了します。"
    return 1
  fi
}

last_total_sec=0
current_total_sec=0
page_id=0
page_total_sec=0
subtitle_csv_str=""
image_list_csv_str=""

# CSVファイルを行ごとに処理
while IFS=',' read -r type arg1 arg2 arg3; do
  # 空行と#から始まるコメント行は無視
  if [[ -z "$type" || "$type" == \#* ]]; then
    continue
  fi

  # 音声合成エンジン判定。csvの最初の行でengineを指定する必要がある。
  if [[ "$type" = "engine" ]]; then
    CSV_ENGINE_NAME="$arg1"
    echo "音声合成エンジンが指定されました: ${CSV_ENGINE_NAME}"
    continue
  fi
  if [[ "$CSV_ENGINE_NAME" != "$ENGINE_NAME" ]]; then
    echo "音声合成エンジン名が正しくありません。"
    echo "想定: ${ENGINE_NAME}, 実態: ${CSV_ENGINE_NAME:-未指定}"
    exit 1
  fi

  # 音声ファイル名 すでに存在していれば利用 なければ作成 ファイル名を安全にするためシェルの特殊文字とスラッシュをアンダースコアで置換
  output_file_name=$(printf "%s_%s_%s_%s.wav" "$type" "$arg1" "$arg2" "$arg3" | sed 's/[*?[\]{}()&|;<>`"'"'"'\\$#\/]/_/g')
  output_file_path="${SOUND_DIR_PATH}${output_file_name}"
  
  text=$arg3

  # 音声ファイルがなければ作成
  if [[ ! -f $output_file_path ]]; then
    if [[ $type == "speak" ]]; then
      _speak $output_file_path $arg1 $arg2 $text
    elif [[ $type == "silent" ]]; then
      silent_time_s=$arg1
      sox -n -r 48000 -c 1 $output_file_path trim 0 $silent_time_s >/dev/null 2>&1
    elif [[ $type == "start-page" ]]; then
      # image_list.csv用ロジック
      ((page_id++))
      page_total_sec=0
      continue
    elif [[ $type == "end-page" ]]; then
      # image_list.csv用ロジック
      page_total_sec_ceil=$(echo "$page_total_sec" | awk '{print int($1)+($1>int($1))}')
      image_list_csv_str+="${page_total_sec_ceil},2,2,${IMAGE_DIR_PATH}image_$(printf "%04d" $page_id).png"$'\n'
      continue
    else
      echo "未対応のtype: $type $arg1 $arg2 $arg3"
      exit 1
    fi
  
    # 音声ファイルが生成できなければ異常終了
    if [[ ! -f $output_file_path ]]; then
      echo $output_file_path $arg1 $arg2 $text
      echo "音声ファイルが作成できませんでした。"
      exit 1
    fi
  fi

  # 音声ファイルをwavリストに追記 絶対パス
  echo $(realpath "$output_file_path") >> $WAV_LIST_FILE_PATH
  # ffmpeg用
  # echo "file '$output_file_path'" >> $WAV_LIST_FILE_PATH

  # 音声ファイルの長さを計算
  wav_file_sec=$(soxi -D $output_file_path)
  current_total_sec=$(echo "$last_total_sec + $wav_file_sec" | bc)
  # image_list.csv用ロジック
  page_total_sec=$(echo "$page_total_sec + $wav_file_sec + 0.15" | bc) # 0.15秒追加は微調整
  echo $wav_file_sec $output_file_path

  if [[ $type == "speak" ]]; then
    # subtitle
    last_total_sec_ceil=$(echo "$last_total_sec" | awk '{print int($1)+($1>int($1))}')
    current_total_sec_ceil=$(echo "$current_total_sec" | awk '{print int($1)+($1>int($1))}')
    echo "last_total_sec_ceil: $last_total_sec_ceil"
    echo "current_total_sec_ceil: $current_total_sec_ceil"
    echo "text: $text"
    subtitle_csv_str+="${last_total_sec_ceil},${current_total_sec_ceil},${text}"$'\n'
  fi

  last_total_sec=$current_total_sec
done < "$NARRATION_FILE_PATH"

echo "=============================="
# 最後の余分な改行を削除
subtitle_csv_str="${subtitle_csv_str%$'\n'}"
echo -e "$subtitle_csv_str"
echo -e "$subtitle_csv_str" > $SUBTITLE_CSV_FILE_PATH
echo "=============================="

# image_list.csv用ロジック
echo "=============================="
# 最後の余分な改行を削除
image_list_csv_str="${image_list_csv_str%$'\n'}"
echo -e "$image_list_csv_str"
echo -e "$image_list_csv_str" > $IMAGE_LIST_FILE_PATH
echo "=============================="


