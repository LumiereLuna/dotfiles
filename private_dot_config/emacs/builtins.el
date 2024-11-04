;; -*- lexical-binding: t -*-

(keymap-global-set "<leader> w" 'whitespace-mode)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'prog-mode-hook 'electric-pair-local-mode)

(use-package info
  :ensure nil
  :defer t
  :preface
  (when (eq system-type 'gnu/linux)
    (with-eval-after-load 'info (progn
                                  (add-to-list 'Info-directory-list "/usr/share/info")
                                  (add-to-list 'Info-directory-list "/usr/local/share/info")))))

(use-package dired
  :ensure nil
  :hook (dired-mode . dired-hide-details-mode)
  :custom
  (dired-listing-switches "-lv --almost-all --group-directories-first --human-readable --classify --time-style long-iso")
  (dired-kill-when-opening-new-dired-buffer t))

(use-package ediff
  :ensure nil
  :custom
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :config
  (defvar-keymap my/flymake-keymap
    :doc "My prefix map for flymake-mode."
    "n" #'flymake-goto-next-error
    "p" #'flymake-goto-prev-error
    "f" #'flymake-mode)
  (keymap-global-set "<leader> f" my/flymake-keymap))

;; https://orgmode.org/
;; https://git.savannah.gnu.org/cgit/emacs/org-mode.git
(use-package org
  :ensure nil
  :hook
  (org-mode . variable-pitch-mode)
  (org-todo-repeat . org-reset-checkbox-state-subtree)
  (after-init . (lambda () (find-file (concat org-directory "/*.org") t)))
  :custom-face
  (org-checkbox ((t (:inherit fixed-pitch))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit fixed-pitch))))
  :custom
  (org-directory `,(expand-file-name "Documents/org" my/home-directory))
  (org-agenda-files `(,org-directory))
  (org-capture-templates '(("d" "default"
                            entry (file+headline "todo.org" "Inbox")
                            "* TODO %?" :prepend t)))
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)")))
  (org-agenda-window-setup 'other-tab)
  (org-agenda-tags-column 0)
  (org-agenda-current-time-string "◀── now ─────────────────────────────────────────────────")
  (org-M-RET-may-split-line nil)
  (org-ellipsis "   […]")
  (org-tags-column 0)
  (org-log-done 'time)
  (org-preview-latex-image-directory `,(expand-file-name "org-latex-preview" temporary-file-directory))
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-image-actual-width '(400))
  (org-agenda-custom-commands '(("n" todo "NEXT"
                                 ((org-agenda-sorting-strategy '(priority-down category-up))))))
  :config
  (defvar-keymap my/org-major-mode-keymap
    :doc "My prefix map for org's major mode."
    "m" #'my/org-sort-media
    "t" #'my/org-sort-todo
    "i" #'org-id-get-create)
  (defvar-keymap my/org-mode-keymap
    :doc "My prefix map for org's global commands."
    "a" #'org-agenda
    "c" #'org-capture
    "l" #'org-store-link)
  (keymap-set global-map "<leader> o" my/org-mode-keymap)
  (keymap-set org-mode-map "<leader> ." my/org-major-mode-keymap)
  (defun my/org-sort-media ()
    (interactive)
    (org-sort-entries nil ?a)
    (org-sort-entries nil ?p)
    (org-sort-entries nil ?o))
  (defun my/org-sort-todo ()
    (interactive)
    (org-sort-entries nil ?p)
    (org-sort-entries nil ?o)))
