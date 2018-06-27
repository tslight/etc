#!/usr/bin/env bash

tangle_tangles () {
    emacs -Q --batch --eval '(with-current-buffer
			     (find-file-noselect "~/etc/emacs/my-tangles.org")
				 (org-babel-tangle))'\
				     2>&1 | grep -Ei 'complete|error'
}

tangle_all () {
    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-all)' 2>&1 | grep -Ei 'complete|error'
}

tangle_emacs () {
    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-init)' 2>&1 | grep -Ei 'complete|error'
}

tangle_dir () {
    local dir="$1"
    emacs -Q --batch -l ~/.emacs.d/site-lisp/my-tangles.el\
	  --eval '(my/tangle-directory "~/etc/'$dir'")' 2>&1 | grep -Ei 'complete|error'
}

main () {
    tangle_tangles
    local arg="$1" dir="$2"
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
