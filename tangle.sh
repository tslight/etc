#!/usr/bin/env bash
OFF="$(tput sgr0)"
GRN="$(tput bold)$(tput setaf 2)"
YEL="$(tput bold)$(tput setaf 3)"

usage() {
    echo "
$(basename "$0") [FILE/s] [-h/--help]

Run Emacs in batch mode to tangle the contents of a file with org-mode.

With no [FILE/s] argument given - tangle all *.org files in the CWD.
"
}

ask() {
    local question="$1"
    while :; do
	read -rep "$question " ans
	case $ans in
	    [Yy]) return 0 ;;
	    [Nn]) return 1 ;;
	    [Qq]) exit 0 ;;
	    *) echo "$ans is invalid. Enter (y)es, (n)o or (q)uit." ;;
	esac
    done
}

tangle_file () {
    local file="$1"
    [[ -f "$file" ]] || { echo "Invalid file"; exit 1; }
    echo "${GRN}Tangling $f....${OFF}"
    emacs --batch \
	  --eval "(require 'org)" \
	  --eval '(org-babel-tangle-file "'$file'")'
    echo "${GRN}Tangling $f done.${OFF}"
}

if [[ -z "$1" ]]; then
    for f in *.org; do
	if ask "${GRN}Tangle $f?${OFF}"; then
	    tangle_file "$f"
	else
	    echo "${YEL}Skipping $f${OFF}"
	fi
    done
else
    case "$1" in
	-h|--help)
	    usage
	    ;;
	*)
	    for f in "$@"; do
		tangle_file "$f"
	    done
	    ;;
    esac
fi
