(defun majitsu-init ()
  (setq majitsu--model
	(list :pending 0
	  :error nil

	  ;; the active node
	  :cursor 0

	  ;; UI nodes
	  :nodes nil)))

(defun majitsu--get-section (model section)
  (plist-get (plist-get model :sections) section))

(defun majitsu--set-section (model section section-data)
  (plist-put model
	     :sections
             (plist-put (plist-get model :sections)
                        section
                        section-data)))

(defun majitsu--set-section-items (model section items)
  (let ((sec (majitsu--get-section model section)))
    (majitsu--set-section model section
                           (plist-put sec :items items))))

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

(majitsu-init)
(majitsu--add-nodes majitsu--model (list (list "foo" 1 3) (list 1 2)))

(provide 'majitsu-model)
;; majitsu-model.el ends here
