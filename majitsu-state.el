(cl-defstruct majitsu--line-state
  prev cur next)

(defun majitsu--next-line (state)
  "Moves the cursor up one line given the STATE struct"
  (if (null (majitsu--line-state-next state))
      state
    (make-majitsu--line-state
     :prev (append (majitsu--line-state-prev state)
                   (list (majitsu--line-state-cur state)))
     :cur (car (majitsu--line-state-next state))
     :next (cdr (majitsu--line-state-next state)))))

(defun majitsu--prev-line (state)
  "Moves the cursor up one line given the STATE struct"
  (if (null (majitsu--line-state-prev state))
      state
    (make-majitsu--line-state
     :prev (take
	    (- (length (majitsu--line-state-prev state)) 1)
	    (majitsu--line-state-prev state))
     :cur (car (last (majitsu--line-state-prev state)))
     :next (cons
	    (majitsu--line-state-cur state)
	    (majitsu--line-state-next state)))))

(provide 'majitsu-state)
;; majitsu-state.el ends here
