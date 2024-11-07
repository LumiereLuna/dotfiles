;; -*- lexical-binding: t -*-

;; Set $HOME as the initial directory regardless of the OS.
(setq default-directory (expand-file-name "./" my/home-directory))

(custom-set-variables '(vc-follow-symlinks t)
                      '(custom-file (make-temp-file "emacs-custom-"))
                      '(confirm-kill-emacs 'y-or-n-p)
                      '(use-short-answers t)
                      '(require-final-newline t)
                      '(sentence-end-double-space nil)
                      '(image-use-external-converter t)
                      '(backward-delete-char-untabify-method 'hungry)
                      '(describe-bindings-outline t)
                      '(delete-by-moving-to-trash t)
                      '(fill-column 70)
                      '(create-lockfiles nil)
                      '(tab-width 8)
                      '(indent-tabs-mode nil))

;; Enable feature without a warning.
(put 'narrow-to-region 'disabled nil)

(use-package autorevert
  :ensure nil
  :custom
  (auto-revert-interval 1)
  (auto-revert-check-vc-info t)
  :config
  (global-auto-revert-mode 1))

(use-package savehist
  :ensure nil
  :config
  (savehist-mode 1))
