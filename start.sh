#!/bin/bash

./main.sh ./data/result/children_book_1/result.mp4 ${PWD}/data/src/project/children_book_1/narration.csv "もりのぼうけんしゃ\nタケルとふしぎなタネ" ${PWD}/data/src/project/children_book_1/title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_1/dalle/ | tee log/20241123_children_book_1.log

# ./main.sh ./data/result/children_book_3/result.mp4 ${PWD}/data/src/project/children_book_3/narration.csv "お菓子の魔法" ${PWD}/data/src/project/children_book_3/3_title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_3/asset/ | tee log/20241122_0250.log


# ./main.sh ./data/result/children_book_4/result.mp4 ${PWD}/data/src/project/children_book_4/narration.csv "シマリス兄弟とふしぎなショッピングモール" ${PWD}/data/src/project/children_book_4/6_title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_4/asset/ | tee log/20241122_0300.log
