(require 'majitsu-process)
(require 'majitsu-render)

(defun majitsu--bookmarks ()
  "Get the currently tracked bookmarks as a bookmark plist."
  (let ((lines (majitsu--lines "b" "l")))
    (mapcar #'majitsu--parse-bookmark lines)))

(defun majitsu--move-bookmark (name)
  "move the bookmake NAME to current revision"
  (majitsu--call "b" "m" name "--allow-backwards"))

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
