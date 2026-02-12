(require 'majitsu-process)
(require 'majitsu-model)

(defun majitsu--update (model msg)
  "Update MODEL in response to MSG.
Return (NEW-MODEL EFFECTS)."
  (pcase msg
    ('refresh
     (list model
           (list '(:bookmarks) '(:status) '(:log))))

    ('next-node
     (list (majitsu--advance-cursor model) nil))

    ('prev-node
     (list (majitsu--reverse-cursor model) nil))

    (`(bookmarks-result ,bookmarks)
     (list (majitsu--add-nodes (majitsu--decrement-pending model)
			       (cons (majitsu--heading-node "Bookmarks")
				     bookmarks))
           nil))

    (`(log-result ,logs)
     (list (majitsu--add-nodes (majitsu--decrement-pending model)
			       (cons
				(majitsu--heading-node "Logs")
				logs))
           nil))

    (`(status-result ,statuses)
     (list (majitsu--add-nodes (majitsu--decrement-pending model) (cons (majitsu--heading-node "Status") statuses))
           nil))

    (_
     (list model nil))))

(defun majitsu--dispatch (msg)
  "Dispatch the MSG to update, render the resulting model and dispatch the effects."
  (pcase-let ((`(,new-model ,effects)
	       (majitsu--update majitsu--model msg)))
    (setq majitsu--model
	  (majitsu--increment-pending new-model (length effects)))
    (majitsu--render majitsu--model)
    (majitsu--dispatch-effects effects)))

(defun majitsu--dispatch-effects (effects)
  "Dispatch the list of EFFECTS"
  (dolist (e effects)
    (majitsu--run-effect e)))

(defun majitsu--run-effect (effect)
  "Switch on the EFFECT type and run it."
  (pcase effect
    ;; log handler
    (`(:log)
     (majitsu--dispatch
      `(log-result ,(majitsu--log-parsed))))

    ;; bookmarks handler
    (`(:bookmarks)
     (majitsu--dispatch
      `(bookmarks-result ,(majitsu--bookmarks))))

    ;; status handler
    (`(:status)
     (majitsu--dispatch
      `(status-result ,(majitsu--status))))))

(provide 'majitsu-update)
;; majitsu-update.el ends here
