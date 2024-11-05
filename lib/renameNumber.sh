#!/bin/bash

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
TMP_DIR=/tmp/__movieToPng_${CURRENT_TIME}/
INPUT_DIR=${1:-"${PWD}/data/src/project/sample/image_list/"}

mkdir $TMP_DIR

pushd $INPUT_DIR
n=1
for file in $(ls output_*.png | sort -V); do
    cp "$file" "${TMP_DIR}image_$(printf "%04d" $n).png"
    ((n++))
done
popd

echo $TMP_DIR
xdg-open $TMP_DIR

