;; -*- lexical-binding: t -*-

(custom-set-variables '(gc-cons-threshold (* 80 1024 1024)))
(setq read-process-output-max (* 5 1024 1024))
(setq inhibit-compacting-font-caches t)

(prefer-coding-system 'utf-8-unix)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setenv "LSP_USE_PLISTS" "true")
