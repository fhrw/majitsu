(defun majitsu--status ()
  "Get the current changed files. Returns a list of file status plists."
  (let ((lines (majitsu--lines "st")))
    (mapcar #'majitsu--parse-status-line (cdr (butlast lines 2)))))

(defun majitsu--parse-status-line (line)
  (when (string-match "^\\([^ ]+\\) +\\(.*\\)$" line)
    (let* ((raw-status (match-string 1 line))
          (raw-path (match-string 2 line))
	  (status (majitsu--status-symbol raw-status)))
      (if (and (memq status '(replaced renamed))
	       (string-match "^{\\(.*\\) => \\(.*\\)}$" raw-path))
	  ;; Rename / replace case
          (list
	   :node-type :status
	   :status status
           :old-path (match-string 1 raw-path)
           :path     (match-string 2 raw-path))
	;; Normal case
        (list
	 :node-type :status
	 :status status
	 :path raw-path)))))

(defun majitsu--status-symbol (code)
  (pcase code
    ("M" 'modified)
    ("A" 'added)
    ("D" 'deleted)
    ("R" 'renamed)
    ("replaced" 'renamed)
    ("renamed" 'renamed)
    ("??" 'untracked)
    (_ (intern code))))

(provide 'majitsu-process-status)
;; majitsu-process-status.el ends here
