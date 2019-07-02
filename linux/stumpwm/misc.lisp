;; interesting lisp findings along the way...
(defun strip-chars (str chars)
  (remove-if (lambda (ch) (find ch chars)) str))

(defun replace-chars (sub chars str)
  (substitute-if sub (lambda (ch) (find ch chars)) str))

(defcommand group-windowlist () ()
  "Windowlist showing all windows from all groups."
  (if-let ((window-list (sort-windows-by-number
			 (mapcan (lambda (s) (screen-windows s)) *screen-list*))))
    (if-let ((window (select-window-from-menu window-list *window-format*)))
      (focus-all window)
      (throw 'error :abort))
    (message "No Managed Windows")))
