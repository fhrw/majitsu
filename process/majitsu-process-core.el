(defcustom maju-jj-executable
  (executable-find "jj")
  "The JJ executable used on the local host"
  :package-version '(maju . "0.1")
  :group 'maju-process
  :type 'string)

(defun maju--call (&rest args)
  "Run jj with ARGS and return its stdout as a string."
  (with-temp-buffer
    (apply #'process-file maju-jj-executable nil (current-buffer) nil args)
    (string-trim (buffer-string))))

(defun maju--lines (&rest args)
  "Return jj output as a list of lines."
  (split-string (apply #'maju--call args) "\n" t))

(defvar maju--process-buffer-name "*majitsu*"
  "Buffer name for Maju process output.")

(defun maju--process-buffer ()
  (get-buffer-create maju--process-buffer-name))

(provide 'majitsu-process-core)
;;; majitsu-process-core.el ends here
