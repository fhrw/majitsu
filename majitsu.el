(require 'majitsu-process)
(require 'majitsu-bookmark)
(require 'majitsu-render)
(require 'majitsu-state)

(defun majitsu ()
  "Entrypoint to Majitsu!"
  (interactive)
  (let ((state (list :bookmarks (majitsu--bookmarks)))
	(st (majitsu--lines "st"))
	(log (majitsu--lines "log"))
	(buf (majitsu--process-buffer)))
    (with-current-buffer buf
      (let ((inhibit-read-only t)
	    (contents (append (mapcar #'majitsu--render-bookmark (plist-get state :bookmarks)) '("-------") st '("-------") log)))
	(majitsu-mode)
	(majitsu--render-lines-to-buffer contents buf)))))

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
