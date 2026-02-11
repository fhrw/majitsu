(defun majitsu--render (model)
  "Render the MODEL to the majitsu-buffer"
  (let ((lines (list (pp-to-string model))))
    (majitsu--render-lines-to-buffer lines (majitsu--process-buffer))))

(defun majitsu--render-lines-to-buffer (lines buf)
  "Clear the majitsu-buffer and write LINES there."
    (with-current-buffer buf
      (erase-buffer)
      (dolist (line lines)
	(insert line "\n")))
    (pop-to-buffer buf))

(defun majitsu--render-divider ()
  "Render a simple divider element."
  "----------")

(provide 'majitsu-render)
;; majitsu-render.el ends here
