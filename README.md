[ja](./README.ja.md)

# Shell.LastNameGenerator.20200902095533

Randomly generate Japanese surnames.

# DEMO

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

# Features

* Randomly generate Japanese surnames
* Extract surname of specified condition
* Use "ruby" and "notation" TSV files as a dictionary

# Requirement

* <time datetime="2020-09-02T09:55:24+0900">2020-09-02</time>
* [Raspbierry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 4 Model B Rev 1.2
* [Raspbian](https://ja.wikipedia.org/wiki/Raspbian) buster 10.0 2019-09-26 <small>[setup](http://ytyaru.hatenablog.com/entry/2019/12/25/222222)</small>
* bash 5.0.3(1)-release

```sh
$ uname -a
Linux raspberrypi 4.19.97-v7l+ #1294 SMP Thu Jan 30 13:21:14 GMT 2020 armv7l GNU/Linux
```

# Installation

```sh
git clone https://github.com/ytyaru/Shell.LastNameGenerator.20200902095536
```

# Usage

```sh
cd Shell.LastNameGenerator.20200902095536/src
./jln.sh
```

Show help.

```sh
./jln.sh -h
```

Show version.

```sh
./jln.sh -v
```

sub commands|概要
------------|----
`g`|名字をランダム生成する。
`s`|部分一致した名字を取得する。
`e`|指定した条件に一致した名字を取得する。

sub commands|Overview
------------|----
`g`|Generate a surnames at random.
`s`|Get the partially matched surname.
`e`|Get the surnames that match the specified conditions.

## `g`: Generate

Randomly generate surnames.

```sh
./jln.sh g
```

Argument|Summary
--------|-------
`-n`|Output count
`-u`|Unique constraint

The value of `-n` is as follows.

Value|meaning
-----|----
`(default value)`|30
`natural number`|specified number
`Negative number`|Maximum number
`0`|No output

The value of `-u` is as follows.

Value|Meaning
-----|-------
`0`|Default (same as `4`)
`1`|None
`2`|"ruby" do not overlap
`3`|"notation" does not overlap
`4`|"ruby" and "notation" do not overlap

The command example is as follows.

```sh
./jln.sh
./jln.sh g
./jln.sh g -n 8
./jln.sh g -u 2
./jln.sh g -n 8 -u 2
./jln.sh | sort
```

## `s`: Select

Select surname.

```sh
./jln.sh s 値 ...
./jln.sh s 'あかさ'
./jln.sh s 'あかさ' '赤'
```

* Search by partial match
* If the argument value has Kanji, it is judged as the refinement condition value of "notation", and if it is not "ruby"
* If you specify multiple arguments, it becomes an `AND` condition.

The following is a Linux command.

```sh
cat "$(DB)" | awk -F "\t" "$COND"
```

The conditional expression `$COND` is as follows. A regular expression in the `awk` syntax.

```sh
$1 ~ /ARG/
$1 ~ /ARG/ && $1 ~ /ARG/
```

The above conditions are searched by partial matching. However, you can search by other methods if you include the regular expression metacharacters in the argument value.

Command example|Search method
---------------|-------------
`./jln.sh s 'あか'`|Partial match
`./jln.sh s '^あか.*'`|Forward match
`./jln.sh s '.*さき$'`|Backward match
`./jln.sh s '^あかさき$'`|Exact match
`./jln.sh s '^あか.{2,}$'`|Regular expression

If you want to avoid entering regular expression metacharacters, use the `e` subcommand below.

## `e`: 抽出

```sh
./jln.sh e [-fbperFBPER COND] ...
./jln.sh e -f 'あか' -f '明'
```
Argument|Meaning|`awk` conditional expression
--------|-------|----------------------------
`-f`|Forward match|`~ /^値.*/`
`-b`|Backward match|`~ /.*値$/`
`-p`|Partial match|`~/値/`
`-e`|Exact match|`~ /^値$/`
`-r`|Regular expression|`~ /値/`

Argument | Meaning | `awk` conditional expression
----|----|-----------
`-F`|Forward match (Not) |`!~ /^値.*/`
`-B`|Backward match (Not)|`!~ /.*値$/`
`-P`|Partial match (Not) |`!~ /値/`
`-E`|Exact match (Not)|`!~ /^値$/`
`-R`|Regular expression (Not)|`!~ /値/`

# Note

* This program should be a TSV file with the following format
    * First row: Ruby (Hiragana)
    * Second column: Notation

# Author

ytyaru

* [![github](http://www.google.com/s2/favicons?domain=github.com)](https://github.com/ytyaru "github")
* [![hatena](http://www.google.com/s2/favicons?domain=www.hatena.ne.jp)](http://ytyaru.hatenablog.com/ytyaru "hatena")
* [![mastodon](http://www.google.com/s2/favicons?domain=mstdn.jp)](https://mstdn.jp/web/accounts/233143 "mastdon")

# License

This software is CC0 licensed.

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.en)

