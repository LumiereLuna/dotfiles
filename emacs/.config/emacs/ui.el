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
                      '(mouse-wheel-flip-direction t)
                      '(line-move-visual nil))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(show-paren-mode 1)
(column-number-mode 1)
(context-menu-mode 1)
(blink-cursor-mode 1)
(global-visual-line-mode 1)
(xterm-mouse-mode 1)

(let ((mymonofont "JetBrains Mono")
      (mysansfont "Roboto"))
  (set-face-attribute 'default nil :family mymonofont :height 110 :width 'expanded)
  (set-face-attribute 'fixed-pitch nil :family mymonofont :height 110 :width 'expanded)
  (set-face-attribute 'variable-pitch nil :family mysansfont :height 120))

;; Syntax highlighting.
(use-package font-lock
  :ensure nil
  :config
  (global-font-lock-mode 1))

(use-package tool-bar
  :ensure nil
  :config
  (tool-bar-mode -1))

(use-package display-line-numbers
  :ensure nil
  :custom
  (display-line-numbers-type 'relative)
  (display-line-numbers-grow-only t)
  :init
  (add-hook 'Info-mode-hook (lambda () (display-line-numbers-mode -1)))
  :config
  (global-display-line-numbers-mode 1))
