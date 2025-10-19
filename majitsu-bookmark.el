(require 'majitsu-process)

(defun majitsu--bookmarks ()
  "Get the currently tracked bookmarks as a bookmark plist."
  (let ((lines (majitsu--lines "b" "l")))
    (mapcar #'majitsu--parse-bookmark lines)))

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
  "Extract the commit SHA from LINE (string)."
  (let ((split (string-split line " " nil)))
    (car (cdr (cdr split)))))

(majitsu--lines "b" "l")
(majitsu--bookmarks)

(provide 'majitsu-bookmark)
;;; majitsu-bookmark.el ends here
