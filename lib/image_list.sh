#!/bin/bash

IMAGE_DIR_PATH=${1:-./data/src/project/children_book_1/dalle/}
# 先頭のドットを取り除く
IMAGE_DIR_PATH=${IMAGE_DIR_PATH#.}
find $(pwd)${IMAGE_DIR_PATH} -type f | sort | awk '{print "16,2,2," $0}'

