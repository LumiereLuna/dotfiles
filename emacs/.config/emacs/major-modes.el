;; -*- lexical-binding: t -*-

;; ########## Tree-sitter ##########

;; Automatic installation, usage, and fallback for tree-sitter major
;; modes in Emacs 29
;; https://github.com/renzmann/treesit-auto
(use-package treesit-auto
  :if (not my/android-system-p)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; ########## Ledger ##########

(use-package hledger-mode
  :defer t)

;; ########## Lua ##########

;; https://github.com/immerrr/lua-mode
(use-package lua-mode
  :defer t)

;; ########## Markdown ##########

;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :defer t
  :hook (markdown-mode . variable-pitch-mode))

;; ########## Web development ##########

(custom-set-variables '(css-indent-offset 2)
                      '(js-indent-level 2))
