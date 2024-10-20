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
