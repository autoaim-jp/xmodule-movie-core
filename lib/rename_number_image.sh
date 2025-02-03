#!/bin/bash

# output
OUTPUT_DIR=${1:-"/tmp/asset_ordered/"}

# input
INPUT_DIR=${2:-"${PWD}/asset/src/project/sample/image_list/"}

mkdir -p $OUTPUT_DIR

pushd $INPUT_DIR
n=1
find . -maxdepth 1 -type f -print0 | sort -zV | while IFS= read -r -d '' file; do
    echo "Processing: $file"
    convert "$file" "${OUTPUT_DIR}image_$(printf "%04d" $n).png"
    ((n++))
done
popd

