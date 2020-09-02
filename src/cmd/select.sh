#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 日本人の名字を指定した条件で抽出する。extract.shの簡略形。extract.shとの違いは位置引数だけ渡せばいい点。そのため否定形が指定できない。また、部分一致のみ。完全一致、前方一致、後方一致、正規表現での絞り込みはできない。
# CreatedAt: 2020-09-01
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$(dirname "$HERE")";
	. "$APP_ROOT/lib/Error.sh"
	. "$APP_ROOT/lib/Join.sh"
	DB() { echo "$APP_ROOT/dic/surnames.tsv"; }
	Help() { eval "echo \"$(cat "$APP_ROOT/doc/help_select.txt")\""; }

	# 漢字を含めば「表記」、漢字を含まねば「読み」と判定する
	InKanji() { [[ ${1} =~ ^.*[亜-熙]+.*$ ]] && return 0 || return 1; }

	# awk構文における抽出条件式を作成する
	declare -a CONDS=();
	for arg; do
		TARGET_NAME=
		InKanji "$arg" && TARGET_NAME='$2' || TARGET_NAME='$1'
		CONDS+=("$TARGET_NAME"' ~ ''/'"$arg"'/')
	done

	# 条件式を && でつなぐ
	local COND_STR="$( IFS=$'\n'; echo "${CONDS[*]}" )"
	COND="$(echo -e "$COND_STR" | Join ' \&\& ')"

	# 条件がないときは全件出力
	[ -z "$COND" ] && COND='{ print $0 }'

	cat "$(DB)" | awk -F "\t" "$COND"
}
Run "$@"
