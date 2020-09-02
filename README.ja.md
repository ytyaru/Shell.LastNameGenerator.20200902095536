[en](./README.md)

# Shell.LastNameGenerator.20200902095533

  日本人の名字（苗字・氏・姓・家名）をランダム生成・指定抽出する。

# デモ

```sh
$ jln.sh
いずいけ	泉池
たけやま	竹山
ほがり	帆苅
はんがいし	半下石
いがた	伊形
おおづつ	大筒
あらいずみ	荒泉
きたいち	北市
いわはた	岩畑
なみもと	浪本
ささもと	佐々本
たかべ	髙部
てなわ	手縄
まきだいら	槙平
うえおく	上奥
きつい	橘井
こがわ	古川
かもさか	加茂坂
おぎさわ	荻澤
しおはま	塩浜
まきぐち	巻口
うるしの	漆野
まつほ	松保
たてさわ	舘澤
おおいで	大井手
おおのこ	大鋸
かとうぎ	加藤木
もりみょう	森明
いいほし	飯干
そねだ	曾根田
```

# 特徴

* 日本人の名字をランダム生成する
* 指定した条件の名字を抽出する
* 「読み」と「表記」のTSVファイルを辞書として使う

# 開発環境

* <time datetime="2020-09-02T09:55:24+0900">2020-09-02</time>
* [Raspbierry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 4 Model B Rev 1.2
* [Raspbian](https://ja.wikipedia.org/wiki/Raspbian) buster 10.0 2019-09-26 <small>[setup](http://ytyaru.hatenablog.com/entry/2019/12/25/222222)</small>
* bash 5.0.3(1)-release

```sh
$ uname -a
Linux raspberrypi 4.19.97-v7l+ #1294 SMP Thu Jan 30 13:21:14 GMT 2020 armv7l GNU/Linux
```

# インストール

```sh
git clone https://github.com/ytyaru/Shell.LastNameGenerator.20200902095536
```

# 使い方

```sh
cd Shell.LastNameGenerator.20200902095536/src
./jln.sh
```

　ヘルプ。

```sh
./jln.sh -h
```

　バージョン。

```sh
./jln.sh -v
```

サブコマンド|概要
------------|----
`g`|名字をランダム生成する。
`s`|部分一致した名字を取得する。
`e`|指定した条件に一致した名字を取得する。

## `g`: 生成

　名字をランダム生成する。

```sh
./jln.sh g
```

引数|概要
----|----
`-n`|出力件数
`-u`|一意制約

　`-n`の値は以下。

値|意味
--|----
`(デフォルト値)`|30
`自然数`|指定した件数
`負数`|最大件数
`0`|何も出力しない

　`-u`の値は以下。

値|意味
--|----
`0`|デフォルト(`4`と同じ)
`1`|なし
`2`|「読み」が重複しない
`3`|「表記」が重複しない
`4`|「読み」と「表記」が重複しない

　コマンド例は以下。

```sh
./jln.sh
./jln.sh g
./jln.sh g -n 8
./jln.sh g -u 2
./jln.sh g -n 8 -u 2
./jln.sh | sort
```

## `s`: 選出

　名字を抽出する。

```sh
./jln.sh s 値 ...
./jln.sh s 'あかさ'
./jln.sh s 'あかさ' '赤'
```

* 部分一致で検索する
* 引数値に漢字があれば「表記」、なければ「読み」の絞込条件値と判定する
* 引数を複数指定すると`AND`条件になる

　Linuxコマンドにすると以下。

```sh
cat "$(DB)" | awk -F "\t" "$COND"
```

　条件式`$COND`は以下のようになる。`awk`構文における正規表現の式。

```sh
$1 ~ /引数値/
$1 ~ /引数値/ && $1 ~ /引数値/
```

　上記の条件は部分一致で検索される。だが、引数値に正規表現メタ文字を含めれば他の方法でも検索できる。

コマンド例|検索方法
----------|--------
`./jln.sh s 'あか'`|部分一致
`./jln.sh s '^あか.*'`|前方一致
`./jln.sh s '.*さき$'`|後方一致
`./jln.sh s '^あかさき$'`|完全一致
`./jln.sh s '^あか.{2,}$'`|正規表現

　正規表現メタ文字の入力を回避したいときは以下`e`サブコマンドを使う。

## `e`: 抽出

　条件を指定して名字を抽出する。

```sh
./jln.sh e [-fbperFBPER COND] ...
./jln.sh e -f 'あか' -f '明'
```

引数|意味|`awk`条件式
----|----|-----------
`-f`|前方一致|`~ /^値.*/`
`-b`|後方一致|`~ /.*値$/`
`-p`|部分一致|`~ /値/`
`-e`|完全一致|`~ /^値$/`
`-r`|正規表現|`~ /値/`

引数|意味|`awk`条件式
----|----|-----------
`-F`|前方一致(否定)|`!~ /^値.*/`
`-B`|後方一致(否定)|`!~ /.*値$/`
`-P`|部分一致(否定)|`!~ /値/`
`-E`|完全一致(否定)|`!~ /^値$/`
`-R`|正規表現(否定)|`!~ /値/`

# 注意

* 本プログラムは以下のような書式のTSVファイルであるべき
    * 1列目: 読み（ひらがな）
    * 2列目: 表記

# 著者

　ytyaru

* [![github](http://www.google.com/s2/favicons?domain=github.com)](https://github.com/ytyaru "github")
* [![hatena](http://www.google.com/s2/favicons?domain=www.hatena.ne.jp)](http://ytyaru.hatenablog.com/ytyaru "hatena")
* [![mastodon](http://www.google.com/s2/favicons?domain=mstdn.jp)](https://mstdn.jp/web/accounts/233143 "mastdon")

# ライセンス

　このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

