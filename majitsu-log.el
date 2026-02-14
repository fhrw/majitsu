(require 'majitsu-process)

(defun maju--log ()
  "Get jj log as a string"
  (maju--call "log"))

(defun maju--log-parsed ()
  "Get the log as lisp data"
  (let ((lines (maju--lines "log" "-T" (majitsu--machine-log-template) "--no-graph")))
    (mapcar #'maju--parse-log-line (mapcar #'read lines))))

(defun maju--current-revision ()
  "Get the current revision as a lisp structure."
  (car (maju--log-parsed)))

(defun maju--parse-log-line (lst)
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

(defun maju--machine-log-template ()
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

(maju--lines "log" "-T" (majitsu--machine-log-template) "--no-graph")

(provide 'majitsu-log)
;; maju-log.el ends here
