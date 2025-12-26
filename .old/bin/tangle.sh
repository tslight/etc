#!/usr/bin/env bash

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
    emacs --batch \
	  --eval "(require 'org)" \
	  --eval '(org-babel-tangle-file "'$file'")'
}

main () {
    if [[ -z "$1" ]]; then
	echo "No argument given tangling all *.org mode files..."
	for f in *.org; do
	    echo "Tangling $f...."
	    tangle_file "$f"
	    echo "Tangling done."
	done
    else
	case "$1" in
	    -h|--help)
		usage
		;;
	    *)
		for f in "$@"; do
		    echo "Tangling $f...."
		    tangle_file "$f"
		    echo "Tangling done."
		done
		;;
	esac
    fi
}

main "$@"
