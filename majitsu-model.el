(defun majitsu-init ()
  (setq majitsu--model
	(list :pending 0
	  :error nil

	  ;; the active node
	  :cursor 0

	  ;; UI nodes
	  :nodes nil)))

(defun majitsu--add-node (model node)
  "Return a new MODEL with NODE appended to its visible node vector."
  (let* ((nodes (plist-get model :visible-nodes))
         (new-nodes (vconcat nodes (vector node))))
    (plist-put model :visible-nodes new-nodes)))

(defun majitsu--add-nodes (model nodes)
  "Return a new MODEL with NODES appended to visible nodes vector."
  (plist-put model :nodes (vconcat (plist-get model :nodes) nodes)))

(defun majitsu--heading-node (heading)
  "Create a section-header node with HEADING text"
  (list
   :node-type :section-header
   :heading heading))

(defun majitsu--decrement-pending (model)
  (let ((pending (plist-get model :pending)))
    (plist-put model :pending (max 0 (1- pending)))))

(defun majitsu--increment-pending (model num-effects)
  (plist-put model
	     :pending
	     (+
	      (or (plist-get model :pending) 0)
	      num-effects)))

(defun majitsu--advance-cursor (model)
  "Move the cursor forward in MODEL."
  (let* ((cursor (plist-get model :cursor))
         (nodes  (plist-get model :nodes))
         (max    (max 0 (1- (length nodes)))))
    (plist-put model :cursor (min (1+ cursor) max))))

(defun majitsu--reverse-cursor (model)
  "Move the cursor backward in MODEL."
  (let ((cursor (plist-get model :cursor)))
    (plist-put model :cursor (max 0 (1- cursor)))))

(provide 'majitsu-model)
;; majitsu-model.el ends here
