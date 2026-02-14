(defun maju--bookmarks ()
  "Get the currently tracked bookmarks as a bookmark plist."
  (let ((lines (maju--lines "b" "l")))
    (mapcar #'maju--parse-bookmark lines)))

(defun maju--bookmarks-alist ()
  "Return an alist of bookmark display strings to bookmark plists."
  (mapcar (lambda (bm)
            (cons (maju--render-bookmark bm) bm))
          (maju--bookmarks)))

(defun maju--prompt-for-bookmark (prompt)
  "Prompt for a bookmark using completing-read and return the plist."
  (let* ((alist (maju--bookmarks-alist))
         (choice (completing-read prompt alist)))
    (alist-get choice alist nil nil #'string=)))

(defun maju--move-bookmark (bookmark)
  "move the BOOKMARK to current revision"
  (maju--call "b" "m" (plist-get bookmark :name) "--allow-backwards"))

(defun maju--push-bookmark (bookmark)
  "Push the BOOKMARK to the remote."
  (maju--call "git" "push" "-b" (plist-get bookmark :name)))

(defun maju--rebase-bookmark (selected target)
  "rebase SELECTED bookmark (whole branch) onto TARGET"
  (maju--call
   "rebase"
   "-r"
   (format "ancestors(\"%s\") & ~ancestors(\"%s\")" selected target)
   "-d"
   target  
   "--skip-emptied"))

(defun maju--render-bookmark (bookmark)
  "Render the given BOOKMARK plist as a string."
  (format "%s  (%s)" (plist-get bookmark :name) (plist-get bookmark :changeid)))

(defun maju--parse-bookmark (line)
  "Parse the given LINE (string) into a plist."
  (list
   :node-type :bookmark-node
   :name (maju--extract-bookmark-name line)
   :changeid (maju--extract-changeid line)
   :commit (maju--extract-commit-sha line)))

(defun maju--extract-bookmark-name (line)
  "Extract the bookmark name from LINE (string)."
  (let ((split (string-split line ":" t)))
    (car split)))

(defun maju--extract-changeid (line)
  "Extract the change-id from LINE (string)."
  (let ((split (string-split line " " nil)))
    (car (cdr split))))

(defun maju--extract-commit-sha (line)
  "Extract the commit-sha from LINE (string)."
  (let ((split (string-split line " " nil)))
    (car (cdr (cdr split)))))


(provide 'majitsu-process-bookmarks)
;; maju-process-bookmarks.el ends here
