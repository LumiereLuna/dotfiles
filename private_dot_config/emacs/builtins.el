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

;; "A client for Language Server Protocol servers."
;; https://joaotavora.github.io/eglot/
;; https://github.com/joaotavora/eglot
(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.1)
  (eglot-ignored-server-capabilities '(:documentHighlightProvider
                                       :colorProvider
                                       :foldingRangeProvider
                                       :documentFormattingProvider
                                       :documentRangeFormattingProvider
                                       :documentOnTypeFormattingProvider))
  :config
  (defvar-keymap my/eglot-keymap
    :doc "My prefix map for eglot-mode."
    "r n" #'eglot-rename
    "r c" #'eglot-reconnect
    "u" #'eglot-update
    "h" #'eglot-inlay-hints-mode
    "a" #'eglot-code-actions
    "s" #'eglot-shutdown
    "e" #'eglot)
  (keymap-global-set "<leader> e" my/eglot-keymap)
  ;; massive perf boost---don't log every event
  (fset #'jsonrpc--log-event #'ignore))
