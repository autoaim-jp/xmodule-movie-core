#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__movieToPng_${CURRENT_TIME}/
INPUT_DIR=${1:-"${PWD}/data/src/project/sample/image_list/"}

mkdir $TMP_DIR

pushd $INPUT_DIR
n=1
find . -maxdepth 1 -type f -name "*.webp" -print0 | sort -zV | while IFS= read -r -d '' file; do
    echo "Processing: $file"
    convert "$file" "${TMP_DIR}image_$(printf "%04d" $n).png"
    ((n++))
done
popd

echo $TMP_DIR
xdg-open $TMP_DIR

