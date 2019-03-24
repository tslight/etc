;;; funsum.el --- Summary:
;;; Code:
;;; Commentary:

(defun my/funsum(numbers)
  "Sum a list of NUMBERS."
  (cond ((eq (length numbers) 1)
	 (car numbers))
	((+ (car numbers)
	    (funsum (cdr numbers))
	    ))
	)
  )

(defun my/getsum(max)
  "Get the sum of a list of numbers from 1 to MAX."
  (interactive "nEnter a number to sum up to: ")
  (setq sum (my/funsum (number-sequence 1 max)))
  (message "%d" sum)
  )

(provide 'funsum)
;;; funsum.el ends here.
