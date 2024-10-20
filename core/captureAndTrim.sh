#!/bin/bash

TMP_CAPTURE_FILE_PATH="${PWD}/data/tmp/tmp/__capture.mp4"
CAPTURE_MOVIE_FILE_PATH=${1:-/tmp/capture.mp4}

ffmpeg -analyzeduration 10M -probesize 32M -y -f x11grab -video_size 1920x1080 -i :1.0+0,0 -framerate 60 $TMP_CAPTURE_FILE_PATH
echo $TMP_CAPTURE_FILE_PATH

ffmpeg -ss 1 -i $TMP_CAPTURE_FILE_PATH -filter_complex "[0]trim=1,setpts=PTS-STARTPTS[b];[b][0]overlay=shortest=1" -shortest -c:a copy $CAPTURE_MOVIE_FILE_PATH

exit

# ffmpeg -ss 1 -i $TMP_CAPTURE_FILE_PATH -ss 2 -i $TMP_CAPTURE_FILE_PATH -c copy -map 1:0 -map 0 -shortest -f nut - | ffmpeg -f nut -i - -map 0 -map -0:0 -c copy $CAPTURE_MOVIE_FILE_PATH
# 
# exit 
# 
# CAPTURE_MOVIE_DURATION=$(ffmpeg -i $TMP_CAPTURE_FILE_PATH 2>&1 | grep "Duration" | awk '{print $2}' | tr -d , | awk -F : '{ print ($1 * 3600) + ($2 * 60) + $3 - 2 }')
# echo "動画の長さ: $CAPTURE_MOVIE_DURATION"
# ffmpeg -i $TMP_CAPTURE_FILE_PATH -ss 1 -t $CAPTURE_MOVIE_DURATION -c copy $CAPTURE_MOVIE_FILE_PATH
# 
# 
# exit 
# 
# ffmpeg -i $TMP_CAPTURE_FILE_PATH -ss 1 -c copy $TMP_CAPTURE_FILE_PATH_TRIM1
# echo $TMP_CAPTURE_FILE_PATH_TRIM1
# ffmpeg -i $TMP_CAPTURE_FILE_PATH_TRIM1 -sseof 1 -c copy $CAPTURE_MOVIE_FILE_PATH
# echo $CAPTURE_MOVIE_FILE_PATH
 
