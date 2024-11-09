#!/bin/bash
# CSVファイルのパスを指定
csv_file="your_file.csv"
# sumPartSecの初期値を設定
sumPartSec=0

# CSVファイルを1行ずつ読み込む
while IFS=, read -r partSec fadeInSec fadeOutSec filePath
do

    # ヘッダ行（#で始まる行）や空行はスキップ
    if [[ "$partSec" =~ ^#.* ]] || [[ -z "$partSec" ]]; then
        continue
    fi

    # partSec - fadeOutSecの計算
    diff=$((partSec - fadeOutSec))
    # sumPartSecの更新
    sumPartSec=$((sumPartSec + partSec))

    # 結果の表示
    echo "partSec: $partSec, fadeOutSec: $fadeOutSec, partSec - fadeOutSec: $diff, sumPartSec: $sumPartSec, sumPartSec + partSec: $((sumPartSec + partSec))"
done < "$csv_file"

