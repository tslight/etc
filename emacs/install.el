#!/usr/bin/env -S emacs --script

(require 'org)

(load-file (car (org-babel-tangle-file
		 (file-truename
		  (concat default-directory "/site-lisp/my-tangles.org")))))

(my/tangle-directory default-directory)
