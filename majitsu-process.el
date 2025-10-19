(defcustom majitsu-jj-executable
  (executable-find "jj")
  "The JJ executable used on the local host"
  :package-version '(majitsu . "0.1")
  :group 'majitsu-process
  :type 'string)

(defun majitsu--call (&rest args)
  "Run jj with ARGS and return its stdout as a string."
  (with-temp-buffer
    (apply #'process-file majitsu-jj-executable nil (current-buffer) nil args)
    (string-trim (buffer-string))))

(defun majitsu--lines (&rest args)
  "Return jj output as a list of lines."
  (split-string (apply #'majitsu--call args) "\n" t))

(defvar majitsu--process-buffer-name "*majitsu*"
  "Buffer name for Majitsu process output.")

(defun majitsu--process-buffer ()
  (get-buffer-create majitsu--process-buffer-name))

(provide 'majitsu-process)
;;; majitsu-process.el ends here
