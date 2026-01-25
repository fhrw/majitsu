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
  (majitsu--move-bookmark (plist-get (majitsu--prompt-for-bookmark "Bookmark to move: ") :name)))

(defun majitsu-push-bookmark ()
  "Prompt for a bookmark and push it to the remote."
  (interactive)
  (majitsu--push-bookmark (majitsu--prompt-for-bookmark "Bookmark to push: ")))

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;

(defun majitsu--bookmarks ()
  "Get the currently tracked bookmarks as a bookmark plist."
  (let ((lines (majitsu--lines "b" "l")))
    (mapcar #'majitsu--parse-bookmark lines)))

(defun majitsu--bookmarks-alist ()
  "Return an alist of bookmark display strings to bookmark plists."
  (mapcar (lambda (bm)
            (cons (majitsu--render-bookmark bm) bm))
          (majitsu--bookmarks)))

(defun majitsu--prompt-for-bookmark (prompt)
  "Prompt for a bookmark using completing-read and return the plist."
  (let* ((alist (majitsu--bookmark-alist))
         (choice (completing-read prompt alist)))
    (alist-get choice alist nil nil #'string=)))

(defun majitsu--move-bookmark (name)
  "move the bookmake NAME to current revision"
  (majitsu--call "b" "m" name "--allow-backwards"))

(defun majitsu--push-bookmark (bookmark)
  "Push the BOOKMARK to the remote."
  (majitsu--call "git" "push" "-b" (plist-get bookmark :name)))

(defun majitsu--rebase-bookmark (selected target)
  "rebase SELECTED bookmark (whole branch) onto TARGET"
  (majitsu--call
   "rebase"
   "-r"
   (format "ancestors(\"%s\") & ~ancestors(\"%s\")" selected target)
   "-d"
   target  
   "--skip-emptied"))

(defun majitsu--render-bookmark (bookmark)
  "Render the given BOOKMARK plist as a string."
  (format "%s  (%s)" (plist-get bookmark :name) (plist-get bookmark :changeid)))

(defun majitsu--parse-bookmark (line)
  "Parse the given LINE (string) into a plist."
  (list
   :name (majitsu--extract-bookmark-name line)
   :changeid (majitsu--extract-changeid line)
   :commit (majitsu--extract-commit-sha line)))

(defun majitsu--extract-bookmark-name (line)
  "Extract the bookmark name from LINE (string)."
  (let ((split (string-split line ":" t)))
    (car split)))

(defun majitsu--extract-changeid (line)
  "Extract the change-id from LINE (string)."
  (let ((split (string-split line " " nil)))
    (car (cdr split))))

(defun majitsu--extract-commit-sha (line)
  "Extract the commit-sha from LINE (string)."
  (let ((split (string-split line " " nil)))
    (car (cdr (cdr split)))))

(provide 'majitsu-bookmark)
;;; majitsu-bookmark.el ends here
