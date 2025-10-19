(require 'majitsu-process)

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
