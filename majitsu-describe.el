(require 'cl-lib)

(defvar-local maju--edit-finish-fn nil
  "Function called with the final text when editing finishes.")

(defvar-local maju--edit-cancel-fn nil
  "Function called when editing is cancelled.")

(defvar maju-describe-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'maju--edit-finish)
    (define-key map (kbd "C-c C-k") #'maju--edit-cancel)
    map))

(define-derived-mode maju-describe-mode text-mode "Majitsu-describe"
  "Major mode for editing Maju descriptions.")

(defun maju--edit-finish ()
  "Finish the current Maju editing session."
  (interactive)
  (let ((text (string-trim (buffer-string)))
        (fn maju--edit-finish-fn))
    (when fn
      (funcall fn text))
    (kill-buffer)))

(defun maju--edit-cancel ()
  "Cancel the current Maju editing session."
  (interactive)
  (when maju--edit-cancel-fn
    (funcall maju--edit-cancel-fn))
  (kill-buffer))

(cl-defun maju-edit-desc (initial &key finish cancel)
  "Edit INITIAL in a describe session.

  FINISH is called with the final text.
  CANCEL is called if editing is aborted."

  (let ((buf (get-buffer-create "*Maju Describe*")))
    (with-current-buffer buf
      (erase-buffer)
      (insert (or initial ""))
      (goto-char (point-min))
      (maju-describe-mode)
      (setq-local maju--edit-finish-fn finish)
      (setq-local maju--edit-cancel-fn cancel))
    (pop-to-buffer buf)))

(provide 'majitsu-describe)
;;; maju-describe.el ends here
