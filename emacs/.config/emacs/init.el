;; -*- lexical-binding: t -*-

(defconst my/android-system-p (string-match "android" (version)))

(defconst my/home-directory (cond ((eq system-type 'gnu/linux)
                                   (getenv "HOME"))
                                  ((eq system-type 'windows-nt)
                                   (convert-standard-filename (getenv "HOMEPATH")))))

(dolist (elfile '("secrets.el"
                  "defaults.el"
                  "pkg-init.el"
                  "ui.el"
                  "builtins.el"
                  "pkgs.el"
                  "major-modes.el"))
  (let ((filepath (expand-file-name elfile user-emacs-directory)))
    (when (file-readable-p filepath)
      (load-file filepath))))
