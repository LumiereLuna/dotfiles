;; -*- lexical-binding: t -*-

;; Automatic installation, usage, and fallback for tree-sitter major
;; modes in Emacs 29
;; https://github.com/renzmann/treesit-auto
(when (not my/android-system-p)
  (use-package treesit-auto
    :config
    (global-treesit-auto-mode)))

;; https://github.com/immerrr/lua-mode
(use-package lua-mode
  :defer t)

;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :defer t
  :hook (markdown-mode . variable-pitch-mode))

(custom-set-variables '(css-indent-offset 2)
                      '(js-indent-level 2))
