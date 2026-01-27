(require 'cl-lib)

(defvar-local majitsu--edit-finish-fn nil
  "Function called with the final text when editing finishes.")

(defvar-local majitsu--edit-cancel-fn nil
  "Function called when editing is cancelled.")

(defvar majitsu-describe-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'majitsu--edit-finish)
    (define-key map (kbd "C-c C-k") #'majitsu--edit-cancel)
    map))

(define-derived-mode majitsu-describe-mode text-mode "Majitsu-describe"
  "Major mode for editing Majitsu descriptions.")

(defun majitsu--edit-finish ()
  "Finish the current Majitsu editing session."
  (interactive)
  (let ((text (string-trim (buffer-string)))
        (fn majitsu--edit-finish-fn))
    (when fn
      (funcall fn text))
    (kill-buffer)))

(defun majitsu--edit-cancel ()
  "Cancel the current Majitsu editing session."
  (interactive)
  (when majitsu--edit-cancel-fn
    (funcall majitsu--edit-cancel-fn))
  (kill-buffer))

(cl-defun majitsu-edit-desc (initial &key finish cancel)
  "Edit INITIAL in a describe session.

  FINISH is called with the final text.
  CANCEL is called if editing is aborted."

  (let ((buf (get-buffer-create "*Majitsu Describe*")))
    (with-current-buffer buf
      (erase-buffer)
      (insert (or initial ""))
      (goto-char (point-min))
      (majitsu-describe-mode)
      (setq-local majitsu--edit-finish-fn finish)
      (setq-local majitsu--edit-cancel-fn cancel))
    (pop-to-buffer buf)))

(provide 'majitsu-describe)
;;; majitsu-describe.el ends here
