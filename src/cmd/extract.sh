#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 日本人の名字を指定した条件で抽出する。引数の値は漢字が含まれていれば名字の「表記」、なければ「読み」の条件値として判定する。-f,-b,-p,-e,-rにて前方一致、後方一致、部分一致、完全一致、正規表現を表す。否定形にするには-F,-B,-P,-E,-Rで表す。
# CreatedAt: 2020-09-01
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$(dirname "$HERE")";
	. "$APP_ROOT/lib/Error.sh"
	. "$APP_ROOT/lib/Join.sh"
	DB() { echo "$APP_ROOT/dic/surnames.tsv"; }
	Help() { eval "echo \"$(cat "$APP_ROOT/doc/help_extract.txt")\""; }

	# 漢字を含めば「表記」、漢字を含まねば「読み」と判定する
	InKanji() { [[ ${1} =~ ^.*[亜-熙]+.*$ ]] && return 0 || return 1; }

	# awk構文における抽出条件式を作成する
	MatchExpOp() { [ 0 -eq $ARG_NOT ] && echo ' ~ ' || echo ' !~ '; }
	RegexExpValue() {
		[ -n "$ARG_FORWARD" ] && { echo '/^'"$1"'.*/'; return; }
		[ -n "$ARG_BACKWARD" ] && { echo '/.*'"$1"'$/'; return; }
		[ -n "$ARG_PARTIAL" ] && { echo '/'"$1"'/'; return; }
		[ -n "$ARG_EXACT" ] && { echo '/^'"$1"'$/'; return; }
		[ -n "$ARG_REGEX" ] && { echo '/'"$1"'/'; return; }
		echo '/'"$1"'/'
	}
	MatchExpression() { echo "$TARGET_NAME""$(MatchExpOp)""$(RegexExpValue "$1")"; }
	declare -a CONDS=(); TARGET_NAME=;
	MakeCond() {
		TARGET_NAME=
		InKanji "$1" && TARGET_NAME='$2' || TARGET_NAME='$1'
		CONDS+=("$(MatchExpression "$1")")
	}

	while getopts :f:b:p:e:r:F:B:P:E:R: OPT; do
		ARG_FORWARD=; ARG_BACKWARD=; ARG_PARTIAL=; ARG_EXACT=; ARG_REGEX=; 
		case $OPT in
			f) ARG_NOT=0; ARG_FORWARD="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			b) ARG_NOT=0; ARG_BACKWARD="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			p) ARG_NOT=0; ARG_PARTIAL="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			e) ARG_NOT=0; ARG_EXACT="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			r) ARG_NOT=0; ARG_REGEX="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			F) ARG_NOT=1; ARG_FORWARD="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			B) ARG_NOT=1; ARG_BACKWARD="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			P) ARG_NOT=1; ARG_PARTIAL="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			E) ARG_NOT=1; ARG_EXACT="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			R) ARG_NOT=1; ARG_REGEX="$OPTARG"; MakeCond "$OPTARG"; continue; ;;
			\?) echo "-${OPTARG} は不正なオプションです。"; Help; exit 1; ;;
		esac
	done

	# 条件式を && でつなぐ
	local COND_STR="$( IFS=$'\n'; echo "${CONDS[*]}" )"
	COND="$(echo -e "$COND_STR" | Join ' \&\& ')"

	# 条件がないときは全件出力
	[ -z "$COND" ] && COND='{ print $0 }'

	cat "$(DB)" | awk -F "\t" "$COND"
#	echo "$COND"
}
Run "$@"
