# 変数命名規則

定数: 大文字スネークケース  
ローカル変数: 小文字スネークケース  
ファイル名: *_FILE  
ディレクトリ名: *_DIR  
ファイル絶対パス: *_FILE_PATH  
ディレクトリ絶対パス: *_DIR_PATH  
ファイル相対パス: 使用しない。PWD等で絶対パスにする。  
ディレクトリ相対パス: 使用しない。PWD等で絶対パスにする。  


# 課題
tmpディレクトリ各種はrmしているところもあるが、マルチプロセスならばrmできない。  


# 引数のわたし方
OUTPUTから渡す。OUTPUTは基本的に増えないから。  

```
./core/module.sh $OUTPUT_VAR $INPUT_VAR1 $INPUT_VAR2
```

# coreの実装方針
単体で動くようにする。  
INPUTは data/src の sample/ から  
OUTPUTは /tmp/  
一時ファイルは data/tmp/tmp/__  (data/tmp/**/　は app側で指定)

# ディレクトリ構造
.  
├── core コアのモジュール　インプットとアウトプットが明確  
├── data スクリプトではないリソース(画像や動画、音声ファイルなど)を配置  
│   ├── capture キャプチャした動画を配置する  
│   ├── generated メイン処理(/*.sh)で生成したもの  
│   │   ├── movie  
│   │   └── sound  
│   ├── src 処理で使うリソース。主にメイン処理(/*.sh)で渡す。  
│   │   └── project プロジェクトごとにリソースを管理  
│   │       ├── my_project  
│   │       └── sample サンプルプロジェクト。コア処理(/core/*.sh)のデフォルト引数。  
│   │           ├── asset  
│   │           ├── image_list  
│   │           ├── image_list_number  
│   │           └── main_part  
│   │               └── part  
│   └── tmp メイン処理(/*.sh)で生成した、最終アウトプットではない結果  
│       ├── capture_subtitle  
│       ├── movie_concat  
│       ├── sound  
│       ├── sound_concat  
│       ├── title_image  
│       ├── title_movie  
│       ├── tmp コア処理(/core/*.sh)で生成した、最終アウトプットではない結果  
│       └── wav_list  
└── lib 未整理のコマンド等  
  
