# xmodule-movie-core

## 課題
tmpディレクトリ各種はrmしているところもあるが、マルチプロセスならばrmできない。  
(済)ディレクトリの命名がバラバラ  →[ディレクトリ構造]を参考に変更。  
(済)変数の命名がバラバラ  →[変数命名規則]を参考に変更。  
(済)引数の渡す順番がバラバラ  →[引数のわたし方]を参考に変更。  
(済)chatgptの画像は1024x1024、他の中央に標示する画像は1920x1080。→とりあえず1024x1024ベースで。  

## 変数命名規則

定数: 大文字スネークケース  
ローカル変数: 小文字スネークケース  
ファイル名: *_FILE  
ディレクトリ名: *_DIR  
ファイル絶対パス: *_FILE_PATH  
ディレクトリ絶対パス: *_DIR_PATH  
ファイル相対パス: 使用しない。PWD等で絶対パスにする。  
ディレクトリ相対パス: 使用しない。PWD等で絶対パスにする。  


## 引数のわたし方
OUTPUTから渡す。OUTPUTは基本的に増えないから。  

```
./core/module.sh $OUTPUT_VAR $INPUT_VAR1 $INPUT_VAR2
```

## coreの実装方針
単体で動くようにする。  
INPUTは asset/src の sample/ から  
OUTPUTは /tmp/  
一時ファイルは data/tmp/tmp/__  (data/tmp/**/　は app側で指定)

## tree directory

`tree -Fd --filesfirst -I ".git/|*.swp|tmp"`

```
.
├── app アプリケーションとして動かせる。core/を呼び出す
├── core コアのモジュール　インプットとアウトプットが明確  
├── data 各種データ
│   ├── capture 画面キャプチャ
│   ├── generated 生成されたファイル
│   │   ├── _common
│   │   │   └── speak_sound 音声ファイルのキャッシュ
│   │   ├── concat_movie
│   │   ├── main_part_from_capture
│   │   ├── main_part_from_image_list
│   │   ├── speak_sound
│   │   ├── subtitle_movie
│   │   ├── telop_image
│   │   └── title_movie
│   └── result 結果。start.shで指定
│        ├── children_book_1
│        ├── children_book_2
│        ├── children_book_3
│        ├── children_book_4
│        └── event1
├── asset フォントファイルとsrc
│   └── src
│       └── project 各プロジェクトのデータ。生成後のものも格納するようになった
│           ├── children_book_1
│           │   ├── asset_ordered
│           │   └── dalle
│           ├── children_book_2
│           │   ├── asset
│           │   └── asset_ordered
│           ├── children_book_3
│           │   ├── asset
│           │   └── asset_ordered
│           ├── children_book_4
│           │   └── asset
│           ├── event1
│           │   └── cut
│           ├── event2
│           │   └── cut
│           ├── sample サンプルプロジェクト。コア処理(/core/*.sh)のデフォルト引数として使用
│           │   ├── asset
│           │   ├── image_list
│           │   ├── image_list_number
│           │   └── main_part
│           │       └── part
│           └── sample2
├── lib まだcoreにしていないもの。
└── log start.shで指定するログディレクトリ
```

## tree file

`tree -Fa --filesfirst -I ".git/|*.swp|tmp|data/|log/"`

```
./
├── .env core/openai.shで使用する、ChatGPTのAPIキーを含む。音声合成用。
├── .env.sample
├── .gitignore
├── README.md
├── edit.sh 動画編集時に使うコマンドのメモ
├── main.sh* ナレーションcsv、タイトル、画像などを渡すと動画を作成する
├── main_capture.sh* ナレーションcsv、タイトル、キャプチャ動画などを渡すと動画を作成する
├── main_dummy.sh* テスト用のスクリプト。main_capture.shの引数がないバージョン
├── start.sh* テスト用のスクリプト。dara/配下のパスを指定してmain.shやmain_capture.shを呼び出す。
├── app/ エントリポイント。各シェルはcore/を呼び出す。
│   ├── capture.sh* キャプチャを取得 captureAndTrim.sh
│   ├── concat_movie.sh* タイトル動画、メインパート動画、音声を結合 concatMovie.sh, concatWavAndMovie.sh
│   ├── main_part_from_capture.sh* キャプチャ動画にテロップを追加 addTelopIntoCapture.sh
│   ├── main_part_from_image_list.sh* ベース動画作成、フェード動画作成、それらを一つに結合 createBasePartMovie.sh, mergeBaseAndFadeMovie.sh, concatMovieFromList.sh
│   ├── speak_sound.sh* 指定された音声合成エンジンのスクリプトを呼び出す、結果の音声ファイルを一つに結合 voicepeak.sh/voicevox.sh/openai.sh/aivisspeech.sh, concatWav.sh
│   ├── subtitle_movie.sh* 動画に字幕をつける addSubtitle.sh
│   ├── telop_image.sh* 3つのテロップ画像を作成 createOwnerImageRT.sh, createMovieThemeImageLT.sh, createMovieTopicImageRB.sh
│   └── title_movie.sh* タイトル画像を作成、タイトルフェード動画を作成 createTitleImage.sh, fadeEffect.sh
├── asset/
│   └── SourceHanSans-Bold.otf
├── core/ 機能。app/から呼び出される。
│   ├── addSubtitle.sh* 動画に字幕をつける
│   ├── addTelopIntoCapture.sh* 四隅のテロップ画像を動画に配置
│   ├── aivisspeech.sh* narration.csvをもとに、aivisspeechで音声合成（http://aivisspeech:10101）
│   ├── captureAndTrim.sh* Ctrl+Cで抜けるまでキャプチャを撮影し、動画の最初と最後の1秒の端末操作をトリミング
│   ├── concatMovie.sh* タイトル動画、ロゴ回転動画、メインパート動画を再エンコードして結合
│   ├── concatMovieFromList.sh* ファイル一覧から動画を結合
│   ├── concatWav.sh* ファイル一覧からsoxで一つのファイルに結合
│   ├── concatWavAndMovie.sh* 動画と音声を結合
│   ├── createBasePartMovie.sh* いくつかのパターンのうち特定のテロップが渡されたら、ベースとなる背景動画を作成
│   ├── createMovieThemeImageLT.sh* 動画の左上のテロップ画像を作成
│   ├── createMovieTopicImageRB.sh* 動画の右下のテロップ画像を作成
│   ├── createOwnerImageRT.sh* 動画の右上のテロップ画像を作成
│   ├── createTitleImage.sh* 画像と文字でタイトル画像を作成
│   ├── fadeEffect.sh* タイトル画像をフェードインフェードアウトの動画に変換
│   ├── mergeBaseAndFadeMovie.sh* 画像を表示または右から左に動く動画を作成し、ベースとなる背景動画にはめ込む
│   ├── openai.sh* narration.csvをもとに、openaiの音声合成apiを呼び出す
│   ├── voicepeak.sh* narration.csvをもとに、voicepeakで音声合成（~/application/Voicepeak/voicepeak）
│   └── voicevox.sh* narration.csvをもとに、voicevoxで音声合成（http://voicevox:50021）
└── lib/ まだcore/に移植していないもの。
    ├── adjust_volume.sh* 動画の音量を変更
    ├── cleanup.sh* git登録時にクリーンアップするもの？
    ├── cut_movie.sh* 秒数を指定して動画を切り取り
    ├── hide.sh* キャプチャ動画のurl部分を隠す
    ├── image_list.sh* 画像一覧のパスを取得
    ├── rename_number_image.sh* 画像を番号順の.pngに変換
    └── speedup.sh* 動画の再生速度を変更
```

