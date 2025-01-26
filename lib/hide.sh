#!/bin/bash

ffmpeg -i ./data/src/project/event1/concat.mp4 -vf "drawbox=x=100:y=70:w=200:h=50:color=#004896:t=fill" -c:a copy ./data/src/project/event1/concat_hide.mp4

