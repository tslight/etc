#!/usr/bin/env -S emacs --script

(require 'org)

(load-file
 (car (org-babel-tangle-file
       (concat default-directory "/emacs/site-lisp/my-tangles.org"))))

(my/tangle-all)
