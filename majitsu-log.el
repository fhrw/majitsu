(require 'majitsu-process)

(defun majitsu--log ()
  "Get jj log as a string"
  (majitsu--call "log"))

(defun majitsu--log-parsed ()
  "Get the log as lisp data"
  (let ((lines (majitsu--lines "log" "-T" (majitsu--machine-log-template) "--no-graph")))
    (mapcar #'majitsu--parse-log-line (mapcar #'read lines))))

(defun majitsu--parse-log-line (lst)
  "Parse the given list of strings into a plist"
  (cl-destructuring-bind
      (changeid name email date time desc)
      lst
    (list
     :changeid changeid
     :name name
     :email email
     :date date
     :timestamp time
     :desc desc)))

(defun majitsu--machine-log-template ()
  "The template string for log formatting to make machine readable.
Note, that in the regular log view, each of these lines will
correspond to TWO lines from the regular view."
  "'(' 
	++ stringify(change_id).escape_json() 
	++ ' ' 
	++ stringify(author.name()).escape_json() 
	++ ' ' 
	++ stringify(author.email()).escape_json() 
	++ ' ' 
	++ stringify(committer.timestamp().format('%v')).escape_json()
	++ ' ' 
	++ stringify(committer.timestamp().format('%X')).escape_json()
	++ ' ' 
	++ stringify(description).trim_end().escape_json()
	++ ')\n'"
  )

(majitsu--lines "log" "-T" (majitsu--machine-log-template) "--no-graph")

(provide 'majitsu-log)
;; majitsu-log.el ends here
