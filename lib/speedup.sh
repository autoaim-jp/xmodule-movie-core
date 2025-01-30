#!/bin/bash

ffmpeg -i ./data/capture/20250128_225026.mp4 -filter:v "setpts=0.5*PTS" -c:v h264_nvenc -b:v 4M -maxrate 6M -bufsize 8M -preset slow -profile:v high -rc-lookahead 32 -preset fast -an ./data/src/project/event2/capture2.mp4

