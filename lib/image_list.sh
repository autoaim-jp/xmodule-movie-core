#!/bin/bash

IMAGE_DIR_PATH=${1:-./data/src/project/children_book_1/dalle/}
find $(pwd)/${IMAGE_DIR_PATH} -type f | sort

