(require 'majitsu-process)
(require 'majitsu-model)

(defun maju--update (model msg)
  "Update MODEL in response to MSG.
Return (NEW-MODEL EFFECTS)."
  (pcase msg
    ('refresh
     (list model
           (list '(:bookmarks) '(:status) '(:log))))

    ('next-node
     (list (maju--advance-cursor model) nil))

    ('prev-node
     (list (maju--reverse-cursor model) nil))

    (`(bookmarks-result ,bookmarks)
     (list (maju--add-nodes (maju--decrement-pending model)
			       (cons (maju--heading-node "Bookmarks")
				     bookmarks))
           nil))

    (`(log-result ,logs)
     (list (maju--add-nodes (maju--decrement-pending model)
			       (cons
				(maju--heading-node "Logs")
				logs))
           nil))

    (`(status-result ,statuses)
     (list (maju--add-nodes (majitsu--decrement-pending model) (cons (majitsu--heading-node "Status") statuses))
           nil))

    (_
     (list model nil))))

(defun maju--dispatch (msg)
  "Dispatch the MSG to update, render the resulting model and dispatch the effects."
  (pcase-let ((`(,new-model ,effects)
	       (maju--update majitsu--model msg)))
    (setq majitsu--model
	  (maju--increment-pending new-model (length effects)))
    (message majitsu--model)
    (maju--dispatch-effects effects))

(defun maju--dispatch-effects (effects)
  "Dispatch the list of EFFECTS"
  (dolist (e effects)
    (maju--run-effect e)))

(defun maju--run-effect (effect)
  "Switch on the EFFECT type and run it."
  (pcase effect
    ;; log handler
    (`(:log)
     (maju--dispatch
      `(log-result ,(maju--log-parsed))))

    ;; bookmarks handler
    (`(:bookmarks)
     (maju--dispatch
      `(bookmarks-result ,(maju--bookmarks))))

    ;; status handler
    (`(:status)
     (maju--dispatch
      `(status-result ,(maju--status))))))

(provide 'majitsu-update)
;; majitsu-update.el ends here
