#!/bin/bash

# voicepeak sample
## ./main.sh ./data/result/children_book_1/result.mp4 ${PWD}/data/src/project/children_book_1/narration.csv "もりのぼうけんしゃ\nタケルとふしぎなタネ" ${PWD}/data/src/project/children_book_1/title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_1/dalle/ "voicepeak" | tee log/20241123_children_book_1.log

## ./main.sh ./data/result/children_book_3/result.mp4 ${PWD}/data/src/project/children_book_3/narration.csv "お菓子の魔法" ${PWD}/data/src/project/children_book_3/3_title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_3/asset/ "voicepeak" | tee log/20241122_0250.log


## ./main.sh ./data/result/children_book_4/result.mp4 ${PWD}/data/src/project/children_book_4/narration.csv "シマリス兄弟とふしぎなショッピングモール" ${PWD}/data/src/project/children_book_4/6_title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_4/asset/ "voicepeak" | tee log/20241122_0300.log

# voicevox sample
# ./main.sh ./data/result/children_book_1/result.mp4 ${PWD}/data/src/project/children_book_1/narration_voicevox.csv "もりのぼうけんしゃ\nタケルとふしぎなタネ" ${PWD}/data/src/project/children_book_1/title.webp "Tempra\nTitans" ${PWD}/data/src/project/children_book_1/dalle/ "voicevox" | tee log/20250123_children_book_1.log

# ./main_capture.sh ./data/src/project/event1/result.mp4 ${PWD}/data/src/project/event1/narration2.csv "ナレーションスタジオ\nなれスタ！\nBBS-AIハッカソン-2024" ${PWD}/data/src/project/event1/tempra.png "Tempra\nTitans" ${PWD}/data/src/project/event1/concat_hide.mp4 "voicepeak" | tee log/20250123_event1.log

./main_capture.sh ./data/src/project/event2/result.mp4 ${PWD}/data/src/project/event2/narration.csv "生成AIで図を作成するツールの紹介" ${PWD}/data/src/project/event2/title.png "-" ${PWD}/data/src/project/event2/concat.mp4 "voicepeak" | tee log/20250128_event2.log

