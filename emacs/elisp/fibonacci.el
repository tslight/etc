;;; fibonacci.el --- Summary:
;;; Code:
;;; Commentary:

(defun my/fibonacci(n)
  "Get the Nth Fibonacci number."
  (if (< n 2)
      n
    (+ (my/fibonacci (- n 1))
       (my/fibonacci (- n 2)))
    )
  )

(defun my/factorial(n)
  "Calculate factorial of N."
  (if (= n 1)
      n
    (* n (my/factorial (- n 1)))
    )
  )

(defun my/recursive-list(range list function)
  "Get recursive LIST of FUNCTION results of RANGE."
  (if (= (length range) 1)
      (funcall function (car range))
    (my/recursive-list (cdr range) )
    )
  )

(defun my/get-fibs(numbers fibonacci)
  "Get all the FIBONACCI NUMBERS."
  (if (equal (length numbers) 1)
      (setq fibonacci (cons (my/fibonacci (car numbers)) fibonacci))
    (my/get-fibs (cdr numbers) fibonacci)
    )
  fibonacci
  )


(my/factorial 18)
(my/fibonacci 18)


(defun my/fibs(number)
  "Get all the Fibonacci numbers up to NUMBER."
  (interactive "nEnter the Fibonacci you want to go up to: ")
  (setq fibs (my/get-fibs (number-sequence 1 number) (list)))
  (message "%s" fibs)
  )

(provide 'fibonacci)
;;; fibonacci.el ends here
