;; interesting lisp findings along the way...
(defun strip-chars (str chars)
  (remove-if (lambda (ch) (find ch chars)) str))

(defun replace-chars (sub chars str)
  (substitute-if sub (lambda (ch) (find ch chars)) str))
