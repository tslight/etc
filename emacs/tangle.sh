#!/usr/bin/env bash
refresh_packages () {
    emacs -Q --batch --eval '(package-refresh-contents)'
}

tangle_tangles () {
    emacs -Q --batch --eval '(with-current-buffer
			     (find-file-noselect "~/etc/emacs/site-lisp/my-tangles.org")
				 (org-babel-tangle))'
}

tangle_all () {
    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-all)'
}

tangle_emacs () {
    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-init)'
}

tangle_dir () {
    local dir="$1"

    [[ -z "$dir" ]] && { echo "Invalid directory"; exit 1; }

    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-directory "~/etc/'$dir'")'
}

main () {
    local arg="$1" dir="$2"

    refresh_packages
    tangle_tangles

    case "$arg" in
	dir)
	    tangle_dir "$dir"
	    ;;
	emacs)
	    tangle_emacs
	    ;;
	all)
	    tangle_all
	    ;;
	*)
	    tangle_all
	    ;;
    esac
}

main "$@"
