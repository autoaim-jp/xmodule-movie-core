#!/bin/bash

# ナレーションcsvを編集（./start.shで指定）
# edit ./asset/src/project/event1/narration2.csv

# 動画を切り取る
./lib/cut_movie.sh ./asset/src/project/event1/cut/70_123.mp4 ./asset/src/project/event1/capture.mp4 643 766

# 結合する動画一覧を編集（次のコマンドで指定）
# edit ./asset/src/project/event1/part_list.txt

# 動画を結合し、concat.mp4を作成
./core/concatMovieFromList.sh ./asset/src/project/event1/concat.mp4 ./asset/src/project/event1/part_list.txt

# concat.mp4の左上のURL部分を隠す
# ./lib/hide.sh ./asset/src/project/event1/concat_hide.mp4 ./asset/src/project/event1/concat.mp4
./lib/hide.sh ./asset/src/project/event1/capture.mp4 ./asset/src/project/event1/capture_hide.mp4

# 動画に音声と字幕をつける
./start.sh

# 動画をひらく
google-chrome "file://$(realpath ./asset/src/project/event1/result.mp4)"

