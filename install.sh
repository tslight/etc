#!/usr/bin/env bash

# Running this script will tangle all the code blocks from the org mode files
# to ~/.emacs.d and load them.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
emacs -Q \
      --eval '(org-babel-load-file "'$DIR/emacs/site-lisp/my-tangles.org'")' \
      --eval '(my/tangle-all)'
