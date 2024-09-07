;; -*- lexical-binding: t -*-

;; ########## Tree-sitter ##########

(setq treesit-language-source-alist '((bash "https://github.com/tree-sitter/tree-sitter-bash")
                                      (c "https://github.com/tree-sitter/tree-sitter-c")
                                      (c++ "https://github.com/tree-sitter/tree-sitter-cpp")
                                      (css "https://github.com/tree-sitter/tree-sitter-css")
                                      (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
                                      (json "https://github.com/tree-sitter/tree-sitter-json")
                                      (python "https://github.com/tree-sitter/tree-sitter-python")
                                      (rust "https://github.com/tree-sitter/tree-sitter-rust")
                                      (toml "https://github.com/ikatyang/tree-sitter-toml")
                                      (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
                                      (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
                                      (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq treesit-load-name-override-list '((c++ "libtree-sitter-c++" "tree_sitter_cpp")))

(cl-loop for (key . value) in treesit-language-source-alist
         do (unless (treesit-language-available-p key)
              (treesit-install-language-grammar key)))

(custom-set-variables '(major-mode-remap-alist '((bash-mode . bash-ts-mode)
                                                 (c-mode . c-ts-mode)
                                                 (c++-mode . c++-ts-mode)
                                                 (css-mode . css-ts-mode)
                                                 (javascript-mode . js-ts-mode)
                                                 (json-mode . json-ts-mode)
                                                 (python-mode . python-ts-mode)
                                                 (rust-mode . rust-ts-mode)
                                                 (toml-mode . toml-ts-mode)
                                                 (tsx-mode . tsx-ts-mode)
                                                 (typescript-mode . typescript-ts-mode)
                                                 (yaml-mode . yaml-ts-mode))))

;; ########## Ledger ##########

(use-package ledger-mode
  :mode "\\.dat\\'")

;; ########## Lua ##########

;; https://github.com/immerrr/lua-mode
(use-package lua-mode
  :defer t)

;; ########## Markdown ##########

;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :defer t
  :hook (markdown-mode . variable-pitch-mode))

;; ########## Python ##########

(when (executable-find "pylsp")
  (add-hook 'python-ts-mode-hook 'eglot-ensure))

;; ########## Web development ##########

(custom-set-variables '(css-indent-offset 2)
                      '(js-indent-level 2))

;; "Emmet is a plugin for many popular text editors which greatly improves HTML
;; & CSS workflow:"
;; https://github.com/smihica/emmet-mode
(use-package emmet-mode
  :ensure nil
  :load-path "forks/emmet-mode/"
  :hook (sgml-mode css-mode))

(when (executable-find "typescript-language-server")
  (add-hook 'js-ts-mode-hook 'eglot-ensure))
