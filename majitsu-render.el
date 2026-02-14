(defun maju--render (model)
  "Render the MODEL to the maju-buffer"
  (let* ((nodes (plist-get model :nodes))
	 (rendered (mapcar #'maju--render-node nodes)))
    (maju--render-lines-to-buffer rendered (majitsu--process-buffer))))

(defun maju--render-lines-to-buffer (lines buf)
  "Clear the maju-buffer and write LINES there."
    (with-current-buffer buf
      (erase-buffer)
      (dolist (line lines)
	(insert line "\n")))
    (pop-to-buffer buf))

(defun maju--render-divider ()
  "Render a simple divider element."
  "----------")

(defun maju--render-node (node)
  "Render NODE to string for writing to maju-buffer."
  (pcase node
  (`(:node-type :section-header :heading ,heading . ,_)
   (maju--render-section-header heading))

  (`(:node-type :bookmark-node :name ,name :changeid ,cid . ,_)
   (maju--render-bookmark name cid))

  (`(:node-type :log-item :changeid ,cid :desc ,desc . ,_)
   (maju--render-log-item cid desc))

  (_
   (message "Unknown node type")))) 

(defun maju--render-section-header (header)
  "Render HEADER node to string."
  (concat header "\n" (maju--render-divider)))

(maju--render-node '(:node-type :section-header :heading "Bookmarks"))


(provide 'majitsu-render)
;; majitsu-render.el ends here
