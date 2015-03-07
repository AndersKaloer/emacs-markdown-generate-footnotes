;; Replaces
;;   [^id footnote text]
;; or
;; [^ footnote text]
;; with
;;   [ref. number]
;; and adds a corresponding
;;   [ref. number]: footnote text
;; in the end of the document.
;; If an id is specified, the id can be used
;; later without footnote text to refer to the same footnote.
(defun markdown-generate-footnotes ()
  (interactive)
  (goto-char (point-min))
  (setq footnote-count 1)
  (setq footnote-text-list ())
  (setq footnote-ids-list ())
  (while (search-forward-regexp "\\[\\(\\^\\([a-zA-Z0-9-_]*\\)[ ]*\\(.*?\\)\\)\\]" nil t)
    ;; Loop through footnotes
    (if (equal "" (match-string 2))
        (progn ;; Id not provided
          (push (cons footnote-count (match-string 3)) footnote-text-list)
          (replace-match (number-to-string footnote-count) nil nil nil 1)
          (setq footnote-count (1+ footnote-count)))
      (progn ;; Id provided
        (if (assoc (match-string 2) footnote-ids-list)
            (replace-match (number-to-string (cdr (assoc (match-string 2) footnote-ids-list))) nil nil nil 1)
          (progn
            (push (cons footnote-count (match-string 3)) footnote-text-list) ; Add to list
            (push (cons (match-string 2) footnote-count) footnote-ids-list)
            (replace-match (number-to-string footnote-count) nil nil nil 1)
            (setq footnote-count (1+ footnote-count)))))))
  
  ;; No more
  (goto-char (point-max))
  (newline)
  (insert "----------")
  (newline)
  (dolist (elm (reverse footnote-text-list))
    (progn
      (insert (format "[%d]: %s" (car elm) (cdr elm)))
      (newline))))
