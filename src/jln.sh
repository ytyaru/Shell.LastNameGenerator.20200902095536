#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 日本人の名字をランダム出力・指定抽出する。
# CreatedAt: 2020-09-02
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$HERE";
	DB() { echo "$HERE/dic/surnames.tsv"; }
	Help() { eval "echo \"$(cat "$HERE/doc/help.txt")\""; }
	Version() { echo '0.0.1'; }
	Generate() { "$HERE/cmd/generate.sh" "$@"; }
	Select() { "$HERE/cmd/select.sh" "$@"; }
	Extract() { "$HERE/cmd/extract.sh" "$@"; }
	# サブコマンド解析
	# 1. 引数なし
	# 2. -h
	# 3. -v
	# 4. g
	# 5. s
	# 6. e
	# 7. 他
	IsExistArgs() { test $# -ne 0;  }
	! IsExistArgs "$@" && { Generate; exit 1; }
	case $1 in
		-h|--help) Help; exit 1; ;;
		-v|--version) Version; exit 1; ;;
		g|gen|generate|generator) Generate "${@:2:($#-1)}"; exit 1; ;;
		s|sel|select|selector) Select "${@:2:($#-1)}"; exit 1; ;;
		e|ext|extract|extractor) Extract "${@:2:($#-1)}"; exit 1; ;;
		\?) Help; exit 1; ;;
	esac
}
Run "$@"
