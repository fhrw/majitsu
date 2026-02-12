(defun majitsu--render (model)
  "Render the MODEL to the majitsu-buffer"
  (let* ((nodes (plist-get model :nodes))
	 (rendered (mapcar #'majitsu--render-node nodes)))
    (majitsu--render-lines-to-buffer (lines rendered) (majitsu--process-buffer))))

(defun majitsu--render-lines-to-buffer (lines buf)
  "Clear the majitsu-buffer and write LINES there."
    (with-current-buffer buf
      (erase-buffer)
      (dolist (line lines)
	(insert line "\n")))
    (pop-to-buffer buf))

(defun majitsu--render-divider ()
  "Render a simple divider element."
  "----------")

(defun majitsu--render-node (node)
  "Render NODE to string for writing to majitsu-buffer."
  (pcase node
  (`(:node-type :section-header :heading ,heading . ,_)
   (majitsu--render-section-header heading))

  (`(:node-type :bookmark-node :name ,name :changeid ,cid . ,_)
   (majitsu--render-bookmark name cid))

  (`(:node-type :log-item :changeid ,cid :desc ,desc . ,_)
   (majitsu--render-log-item cid desc))

  (_
   (message "Unknown node type")))) 

(defun majitsu--render-section-header (header)
  "Render HEADER node to string."
  (concat header "\n" (majitsu--render-divider)))

(majitsu--render-node '(:node-type :section-header :heading "Bookmarks"))


(provide 'majitsu-render)
;; majitsu-render.el ends here
