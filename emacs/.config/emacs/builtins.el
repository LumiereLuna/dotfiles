;; -*- lexical-binding: t -*-

(keymap-global-set "<f4>" 'whitespace-mode)
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

;; https://orgmode.org/
;; https://git.savannah.gnu.org/cgit/emacs/org-mode.git
(use-package org
  :ensure nil
  :preface
  (defun my/open-all-org-files ()
    (interactive)
    (find-file (concat org-directory "/*.org") t))
  (defun my/org-make-place-views (key-values)
    (let (final-list)
      (dolist (key-value key-values final-list)
        (let ((tag (car (cdr key-value)))
              (tecla (car key-value)))
          (push
           `(,tecla
             ,tag
             ((tags-todo ,(concat "+" tag) ((org-agenda-overriding-header "Aquí")))
              (tags-todo "-{@.*}" ((org-agenda-overriding-header "Doquier")))
              (todo "NEXT" ((org-agenda-files '("media.org")) (org-agenda-overriding-header "Media"))))
             ((org-agenda-files '("inbox.org")) (org-agenda-sorting-strategy '(priority-down todo-state-down)) (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))))
           final-list)))))
  (defun my/org-capture-default ()
    (interactive)
    (org-capture nil "d"))
  (defun my/org-agenda ()
    (interactive)
    (org-revert-all-org-buffers)
    (org-agenda))
  :hook
  (org-mode . variable-pitch-mode)
  (org-todo-repeat . org-reset-checkbox-state-subtree)
  (after-init . my/open-all-org-files)
  :bind
  (("<leader> o a" . org-agenda)
   ("<leader> o c" . my/org-capture-default)
   ("<leader> o l" . org-store-link)
   ("<leader> o r" . org-revert-all-org-buffers))
  :custom
  (org-directory (expand-file-name "org" my/home-directory))
  (org-agenda-files (expand-file-name "agenda.txt" org-directory))
  (org-capture-templates '(("d" "default"
                            entry (file "inbox.org")
                            "* TODO %?")))
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "DROP(p)")))
  (org-agenda-tags-column 0)
  (org-agenda-span 'day)
  (org-M-RET-may-split-line nil)
  (org-ellipsis "   […]")
  (org-tags-column 0)
  (org-log-done 'time)
  (org-preview-latex-image-directory (expand-file-name "org-latex-preview" temporary-file-directory))
  (org-image-actual-width '(400))
  (org-agenda-custom-commands (my/org-make-place-views '(("c" "@casa") ("j" "@trabajo") ("p" "@super") ("f" "@afuera"))))
  (org-tag-persistent-alist '((:startgroup . nil)
                              ("@casa" . ?c)
                              ("@trabajo" . ?j)
                              ("@super" . ?p)
                              ("@afuera" . ?f)
                              (:endgroup . nil)))
  (org-refile-targets '((nil :maxlevel . 8)
                        (org-agenda-files :level . 1)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-fast-tag-selection-single-key t))
