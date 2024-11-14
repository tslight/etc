#!/usr/bin/env bash

usage() {
    echo "
$(basename "$0") [DIRECTORY] [-a/--all] [-h/--help]

Run Emacs in batch mode to either tangle the contents of a specific directory
or all my org mode configuration files.
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
        echo "Needs an org file as an argument."
    else
        case "$1" in
            -h|--help)
                usage
                ;;
            *)
                tangle_file "$1"
                ;;
        esac
    fi
}

main "$@"
