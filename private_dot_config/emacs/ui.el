;; -*- lexical-binding: t -*-

(custom-set-variables '(custom-safe-themes t)
                      '(line-spacing 0.3)
                      '(show-paren-context-when-offscreen 'child-frame)
                      '(prettify-symbols-unprettify-at-point t)
                      '(column-number-indicator-zero-based nil)
                      '(mode-line-compact 'long)
                      '(blink-cursor-delay 1.0)
                      '(blink-cursor-interval 1.0)
                      '(blink-cursor-blinks 5)
                      '(window-resize-pixelwise t)
                      '(frame-resize-pixelwise t)
                      '(mouse-wheel-tilt-scroll t)
                      '(mouse-wheel-flip-direction t))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(show-paren-mode 1)
(column-number-mode 1)
(line-number-mode -1)
(context-menu-mode 1)
(blink-cursor-mode 1)
(global-visual-line-mode 1)

(let ((mymonofont "IBM Plex Mono")
      (mysansfont "Roboto"))
  (when (and (member mymonofont (font-family-list))
             (member mysansfont (font-family-list)))
    (set-face-attribute 'default nil :family mymonofont :height 120)
    (set-face-attribute 'fixed-pitch nil :family mymonofont :height 120)
    (set-face-attribute 'variable-pitch nil :family mysansfont :height 130)))

;; Syntax highlighting.
(use-package font-lock
  :ensure nil
  :config
  (global-font-lock-mode 1))

(use-package tool-bar
  :ensure nil
  :config
  (tool-bar-mode -1))

(use-package tab-bar
  :ensure nil
  :config
  (defvar-keymap my/tab-bar-keymap
    :doc "My prefix map for Emacs' tab-bar."
    "n" #'tab-bar-new-tab
    "k" #'tab-bar-close-tab
    "l" #'tab-bar-move-tab
    "h" #'tab-bar-move-tab-backward)
  (keymap-global-set "<leader> t" my/tab-bar-keymap)
  (tab-bar-mode 1))

(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode text-mode)
  :custom-face
  (line-number ((t (:inherit fixed-pitch))))
  :custom
  (display-line-numbers-type 'visual)
  (display-line-numbers-grow-only t))
