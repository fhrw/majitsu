(require 'majitsu-process)
(require 'majitsu-log)
(require 'majitsu-describe)

(defun maju-describe-current-rev-buffer ()
  "Edit the existing description in a buffer."
  (interactive)
  (let* ((current-desc (plist-get (maju--current-revision) :desc)))
    (maju-edit-desc
     current-desc
     :finish (lambda (msg)
	       (maju--call "desc" "-m" msg))
     :cancel (lambda ()
	       (message "Description edit cancelled.")))))

(defun maju-desc-current-rev ()
  "Add a description to the current commit."
  (interactive)
  (let* ((current-desc (or (plist-get (maju--current-revision) :desc) ""))
         (new-desc (read-string "Description: " current-desc)))
    (maju--call "describe" "-m" new-desc)))

(provide 'majitsu-rev)
;;; majitsu-rev.el ends here
