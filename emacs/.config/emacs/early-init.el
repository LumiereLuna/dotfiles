;; -*- lexical-binding: t -*-

(defconst my/android-system-p (string-match "android" (version)))

(custom-set-variables '(gc-cons-threshold (if my/android-system-p
                                              (* 30 1024 1024)
                                            (* 80 1024 1024))))
(when (not my/android-system-p)
  (setq read-process-output-max (* 1024 1024)))
(setq inhibit-compacting-font-caches t)

(prefer-coding-system 'utf-8-unix)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setenv "LSP_USE_PLISTS" "true")
