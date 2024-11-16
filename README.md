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
├── core
├── data
│   ├── capture
│   ├── generated
│   │   ├── movie
│   │   └── sound
│   ├── src
│   │   └── project
│   │       ├── my_project
│   │       └── sample
│   │           ├── asset
│   │           ├── image_list
│   │           ├── image_list_number
│   │           └── main_part
│   │               └── part
│   └── tmp
│       ├── capture_subtitle
│       ├── movie_concat
│       ├── sound
│       ├── sound_concat
│       ├── title_image
│       ├── title_movie
│       ├── tmp
│       └── wav_list
├── lib
└── tmp
    └── tmp
        └── __newsFrame_20241116_183529
            └── part

