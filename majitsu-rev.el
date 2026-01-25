(require 'majitsu-process)
(require 'majitsu-log)

(defvar majitsu--desc-buffer-name "*majitsu-description*"
  "Buffer name used for editing majitsu revision descriptions.")

(defun majitsu--desc-buffer ()
  (get-buffer-create majitsu--desc-buffer-name))

(defun majitsu-desc-current-rev ()
  "Add a description to the current commit."
  (interactive)
  (let* ((current-desc (or (plist-get (majitsu--current-revision) :desc) ""))
         (new-desc (read-string "Description: " current-desc)))
    (majitsu--call "describe" "-m" new-desc)))

(provide 'majitsu-rev)
;;; majitsu-rev.el ends here
