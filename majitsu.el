(require 'majitsu-process)
(require 'majitsu-render)
(require 'majitsu-model)
(require 'majitsu-update)

(defun majitsu ()
  "Entrypoint to Majitsu!"
  (interactive)
  (let ((buf (majitsu--process-buffer)))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
	(majitsu-mode)
	(maju-init)
	(maju--dispatch 'refresh)
	(maju--render majitsu--model)))))

(defvar-local majitsu--model nil)

(define-derived-mode majitsu-mode special-mode "Majitsu"
  "Major mode for majitsu."
  (setq buffer-read-only t))

(defvar majitsu-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") #'majitsu)
    map)
  "Keymap for `majitsu-mode`.")

(provide 'majitsu)
;; majitsu.el ends here
