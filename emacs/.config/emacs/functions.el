;; -*- lexical-binding: t -*-

(defun my/replace-fancy-apostrophes ()
  "Replace typographically accurate apostrophes with typewriter apostrophes."
  (interactive)
  ;; Copied from:
  ;; https://emacs.stackexchange.com/questions/21519/programmatically-replace-all-instances-of-regex-with-capture-groups-and-sub-matc
  (goto-char (point-min))
  (while (re-search-forward "\\([a-zA-Z]\\)’\\([a-zA-Z]\\)" nil t)
    (replace-match "\\1'\\2")))

(keymap-global-set "<leader> '" #'my/replace-fancy-apostrophes)
