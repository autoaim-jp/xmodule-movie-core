#!/bin/bash

ROOT_DIR_PATH=$(dirname "$0")/../
DATA_DIR_PATH="${ROOT_DIR_PATH}data/"
##SAMPLE_PROJECT_DIR_PATH=${ROOT_DIR_PATH}data/src/project/sample/
##CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# tmpディレクトリのクリーンアップ
rm -rf ${DATA_DIR_PATH}tmp/

# 念のためtmp/tmpまで作成しておく
mkdir -p ${DATA_DIR_PATH}tmp/tmp/

