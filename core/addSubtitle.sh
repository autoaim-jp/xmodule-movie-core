#!/bin/bash

CAPTURE_MOVIE_FILE_PATH=${1:-"${PWD}/data/src/sample/capture.mp4"}
SUBTITLE_MOVIE_FILE_PATH=${2:-/tmp/subtitle.mp4}

# 字幕を表示
ffmpeg -i $CAPTURE_MOVIE_FILE_PATH \
  -vf "drawtext=text='xloginアカウントでログインします。':fontfile=/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf:fontcolor=white:boxborderw=10:box=1:boxcolor=0x333333@0.8:fontsize=24:x=(w-text_w)/2:y=h-50:enable='between(t,0,4)',drawtext=text='「テキストの取得と保存」の権限が必要なので、チェックします。':fontfile=/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf:fontcolor=white:boxborderw=10:box=1:boxcolor=0x333333@0.8:fontsize=24:x=(w-text_w)/2:y=h-50:enable='between(t,5,9)',drawtext=text='企業名と、四半期の損益計算書の値を入力します。':fontfile=/usr/share/fonts/opentype/source-han-sans/SourceHanSans-Regular.otf:fontcolor=white:boxborderw=10:box=1:boxcolor=0x333333@0.8:fontsize=24:x=(w-text_w)/2:y=h-50:enable='between(t,10,22)'" \
  $SUBTITLE_MOVIE_FILE_PATH

