(require 'majitsu-process)
(require 'majitsu-log)
(require 'majitsu-describe)

(defun majitsu-describe-current-rev-buffer ()
  "Edit the existing description in a buffer."
  (interactive)
  (let* ((current-desc (plist-get (majitsu--current-revision) :desc)))
    (majitsu-edit-desc
     current-desc
     :finish (lambda (msg)
	       (majitsu--call "desc" "-m" msg))
     :cancel (lambda ()
	       (message "Description edit cancelled.")))))

(defun majitsu-desc-current-rev ()
  "Add a description to the current commit."
  (interactive)
  (let* ((current-desc (or (plist-get (majitsu--current-revision) :desc) ""))
         (new-desc (read-string "Description: " current-desc)))
    (majitsu--call "describe" "-m" new-desc)))

(provide 'majitsu-rev)
;;; majitsu-rev.el ends here
