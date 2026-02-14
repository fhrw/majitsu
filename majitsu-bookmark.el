(require 'majitsu-process)
(require 'majitsu-render)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Interactive Commands ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun maju-rebase-bookmark ()
  "Prompt for the SELECTED bookmark and then rebase it and all parent commits onto TARGET."
  (interactive)
  (let ((selected (maju--prompt-for-bookmark "Bookmark to rebase: "))
	(target (maju--prompt-for-bookmark "Bookmark to rebase onto: ")))
    (maju--rebase-bookmark (plist-get selected :name) (plist-get target :name))))

(defun maju-move-bookmark-to-current ()
  "Prompt for a bookmark and move it to the current position."
  (interactive)
  (maju--move-bookmark (majitsu--prompt-for-bookmark "Bookmark to move: ")))

(defun maju-push-bookmark ()
  "Prompt for a bookmark and push it to the remote."
  (interactive)
  (maju--push-bookmark (majitsu--prompt-for-bookmark "Bookmark to push: ")))

(provide 'majitsu-bookmark)
;;; maju-bookmark.el ends here
