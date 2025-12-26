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
    echo "${YEL}No argument given tangling all *.org mode files...${OFF}"
    for f in *.org; do
	tangle_file "$f"
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
