#!/usr/bin/env bash
# 標準入力値を文字列結合する。標準入力値の改行コードを第一引数値で置換する。
# stdin: 結合したい値（区切文字は改行\n）
# $1: 結合時の区切文字（デフォルトは半角空白）
# 例:
#  $ . Join.sh
#  $ echo -e 'A\nB\nC' | Join ' \&\& '
#  A && B && C
Join() {
	local DELIMITER="${1:- }"
	local STR="$(echo -e "$(cat -)" | sed -z 's/\n/'"$DELIMITER"'/g')"
	echo "${STR%$DELIMITER}"
}

