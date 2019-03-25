;;; fibonacci.el --- Summary:
;;; Code:
;;; Commentary:

(defun my/fibonacci(n)
  "Get the Nth Fibonacci number."
  (cond ((< n 2) n)
	((my/fibonacci (+ (- n 1) (- n 2))))
	)
  )

(defun my/get-fibs(numbers)
  "Get all the Fibonacci numbers up to NUMBER."
  (cond ((eq (length numbers) 1)
	 (car )))
  )

(defun my/fibs(number)
  "Get all the Fibonacci numbers up to NUMBER."
  (interactive "nEnter the Fibonacci you want to go up to: ")
  (setq fibs (my/get-fibs (number-sequence 1 number)))
  )
