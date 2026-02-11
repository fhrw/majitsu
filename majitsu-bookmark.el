(require 'majitsu-process)
(require 'majitsu-render)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Interactive Commands ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun majitsu-rebase-bookmark ()
  "Prompt for the SELECTED bookmark and then rebase it and all parent commits onto TARGET."
  (interactive)
  (let ((selected (majitsu--prompt-for-bookmark "Bookmark to rebase: "))
	(target (majitsu--prompt-for-bookmark "Bookmark to rebase onto: ")))
    (majitsu--rebase-bookmark (plist-get selected :name) (plist-get target :name))))

(defun majitsu-move-bookmark-to-current ()
  "Prompt for a bookmark and move it to the current position."
  (interactive)
  (majitsu--move-bookmark (majitsu--prompt-for-bookmark "Bookmark to move: ")))

(defun majitsu-push-bookmark ()
  "Prompt for a bookmark and push it to the remote."
  (interactive)
  (majitsu--push-bookmark (majitsu--prompt-for-bookmark "Bookmark to push: ")))

(provide 'majitsu-bookmark)
;;; majitsu-bookmark.el ends here
