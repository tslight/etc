;;; fibonacci.el --- Summary:
;;; Code:
;;; Commentary:

(defun my/fibonacci(max)
  "Get all the fibonacci numbers up MAX."
  (interactive "nEnter a number to get fibonacci number up to: ")
  (cond ((< max 2) max)
	((my/fibonacci (+ (- max 1) (- max 2))))
	)
  )
