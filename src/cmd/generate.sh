#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 日本人の名字をランダム出力する。重複排除。
# CreatedAt: 2020-09-02
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$(dirname "$HERE")";
	. "$APP_ROOT/lib/Error.sh"
	DB() { echo "$APP_ROOT/dic/surnames.tsv"; }
	Help() { eval "echo \"$(cat "$APP_ROOT/doc/help_generate.txt")\""; }

	while getopts :n:u: OPT; do
		case $OPT in
			n) ARG_NUM="$OPTARG"; continue; ;;
			u) ARG_COND_UNIQ="$OPTARG"; continue; ;;
			\?) Help; exit 1; ;;
		esac
	done
	ARG_NUM="${ARG_NUM:-30}"
	ARG_COND_UNIQ="${ARG_COND_UNIQ:-4}"
	CheckArgs() {
		IsInt() { test 0 -eq $1 > /dev/null 2>&1 || expr $1 + 0 > /dev/null 2>&1; }
		IsInt "$ARG_NUM" || { Throw '引数 n は1以上の自然数であるべきです。'; }
		IsInt "$ARG_COND_UNIQ" || { Throw '引数 u は0〜4の自然数であるべきです。'; }
		[ $ARG_COND_UNIQ -lt 0 ] && { Throw '引数 u は0〜4の自然数であるべきです。'; }
		[ 4 -lt $ARG_COND_UNIQ ] && { Throw '引数 u は0〜4の自然数であるべきです。'; }
		# なぜか以下がないと何も出力されなくなってしまう。バグ？
		echo -n ''
	}
	CheckArgs

	# 出力件数が負数なら全件出力する
	[ $ARG_NUM -lt 0 ] && NUM=$(cat $(DB) | wc -l) || NUM=$ARG_NUM

	# awk構文における抽出条件式を作成する
	[ $ARG_COND_UNIQ -eq 0 ] && COND_UNIQ='!a[$1]++ && !b[$2]++'
	[ $ARG_COND_UNIQ -eq 1 ] && COND_UNIQ='{ print $0 }'
	[ $ARG_COND_UNIQ -eq 2 ] && COND_UNIQ='!a[$1]++'
	[ $ARG_COND_UNIQ -eq 3 ] && COND_UNIQ='!b[$2]++'
	[ $ARG_COND_UNIQ -eq 4 ] && COND_UNIQ='!a[$1]++ && !b[$2]++'

	cat "$(DB)" | awk -F "\t" "$COND_UNIQ" | shuf -n $NUM
#	echo "$NUM"
#	echo "$COND_UNIQ"
}
Run "$@"
