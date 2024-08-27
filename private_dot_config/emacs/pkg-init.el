;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(custom-set-variables '(use-package-always-demand t))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; "[Changes] the values of path variables to put configuration files
;; in no-littering-etc-directory […] and persistent data files in
;; no-littering-var-directory […]"
;; https://github.com/emacscollective/no-littering
(use-package no-littering)

;; "This package provides functionality for automatically updating
;; your Emacs packages periodically."
;; https://github.com/rranelli/auto-package-update.el
(use-package auto-package-update
  :init
  (add-hook 'auto-package-update-after-hook (lambda () (setq confirm-kill-emacs nil) (restart-emacs)))
  (setq auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-at-time "07:00"))
