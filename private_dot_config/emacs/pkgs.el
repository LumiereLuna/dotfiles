;; -*- lexical-binding: t -*-

;; ########## Vim emulation ##########

;; https://github.com/emacs-evil/evil
(use-package evil
  :custom
  (evil-undo-system 'undo-redo)
  (evil-want-keybinding nil)
  (evil-complete-all-buffers nil)
  (evil-want-C-u-scroll t)
  (evil-want-C-u-delete t)
  ;; Makes the Tab key work properly while in org-mode. This is so
  ;; because Tab and Ctrl+I are considered the same thing in terminals
  ;; because of Unix legacy reasons, and evil-mode shadows org's Tab
  ;; key command.
  (evil-want-C-i-jump nil)
  (evil-respect-visual-line-mode t)
  :config
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-mode 1)
  (evil-set-initial-state 'dired-mode 'emacs))

;; "This is a collection of Evil bindings for the parts of Emacs that Evil does
;; not cover properly by default, such as help-mode, M-x calendar, Eshell and
;; more."
;; https://github.com/emacs-evil/evil-collection
(use-package evil-collection
  :config
  (delete 'vterm evil-collection-mode-list)
  (delete 'info evil-collection-mode-list)
  (delete 'dired evil-collection-mode-list)
  (evil-collection-init))

;; "Supplemental evil-mode key-bindings to Emacs org-mode."
;; https://github.com/Somelauw/evil-org-mode
(use-package evil-org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; ########## UX improvements ##########

;; "Consult provides search and navigation commands based on the Emacs
;; completion function completing-read."
;; https://github.com/minad/consult
(use-package consult
  :bind
  (("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-s" . consult-line))
  :custom
  (consult-narrow-key "<")
  (consult-fd-args '((if (executable-find "fdfind" 'remote)
                         "fdfind"
                       "fd")
                     "--full-path --color=never --hidden"))
  (consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob !.git/")
  (consult-preview-key `,(list :debounce 0.5 'any))
  :config
  (defvar-keymap my/consult-keymap
    :doc "My prefix map for consult."
    "f" #'consult-fd
    "r" #'consult-ripgrep
    "l" #'consult-flymake
    "o" #'consult-outline)
  (keymap-global-set "<leader> c" my/consult-keymap))

;; "Vertico provides a performant and minimalistic vertical completion
;; UI based on the default completion system. The focus of Vertico is
;; to provide a UI which behaves correctly under all circumstances. By
;; reusing the built-in facilities system, Vertico achieves full
;; compatibility with built-in Emacs completion commands and
;; completion tables."
;; https://github.com/minad/vertico
(use-package vertico
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  :config
  (vertico-mode 1))

;; "Commands for Ido-like directory navigation."
;; https://github.com/minad/vertico
(use-package vertico-directory
  :ensure nil
  :after vertico
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind
  (:map vertico-map
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word)))

;; "This package provides an orderless completion style that divides
;; the pattern into space-separated components, and matches candidates
;; that match all of the components in any order."
;; https://github.com/oantolin/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  :config
  (setq completion-category-defaults nil))

;; "This package provides marginalia-mode which adds marginalia to the
;; minibuffer completions."
;; https://github.com/minad/marginalia/
(use-package marginalia
  :config
  (marginalia-mode 1))

;; "Embark makes it easy to choose a command to run based on what is near point,
;; both during a minibuffer completion session (in a way familiar to Helm or
;; Counsel users) and in normal buffers."
;; https://github.com/oantolin/embark
(use-package embark
  :bind
  (("C-c a" . embark-act)))

;; "If you use both Consult and Embark you should install the embark-consult
;; package which provides integration between the two."
(use-package embark-consult)

;; ########## Completion popup ##########

;; "Enhances in-buffer completion with a small completion popup."
;; https://github.com/minad/corfu
(use-package corfu
  :bind
  ;; Use TAB for cycling, default is `corfu-complete'.
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("M-o" . corfu-insert-separator))
  :custom
  (corfu-auto t)
  (corfu-preselect 'prompt)
  :config
  (global-corfu-mode)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1))

;; "Corfu uses child frames to display candidates. This makes Corfu
;; unusable on terminal. This package replaces that with popup/popon,
;; which works everywhere."
;; https://codeberg.org/akib/emacs-corfu-terminal
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode 1))

;; "Cape provides Completion At Point Extensions which can be used in
;; combination with Corfu, Company or the default completion UI."
;; https://github.com/minad/cape
(use-package cape
  :init
  ;; Enable cache busting, depending on if your server returns
  ;; sufficiently many candidates in the first place.
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; ########## Programming ##########

;; "Unobtrusively trim extraneous white-space *ONLY* in lines edited."
;; https://github.com/lewang/ws-butler
(use-package ws-butler
  :hook (prog-mode text-mode))

;; "Magit is an interface to the version control system Git,
;; implemented as an Emacs package."
;; https://github.com/magit/magit
(use-package magit
  :defer t)

;; "Client for Language Server Protocol (v3.14). lsp-mode aims to
;; provide IDE-like experience by providing optional integration with
;; the most popular Emacs packages like company, flycheck and
;; projectile."
;; https://github.com/emacs-lsp/lsp-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  ((js-mode js-ts-mode python-mode python-ts-mode) . lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-idle-delay 0.500))

;; "UI integrations for lsp-mode"
;; https://github.com/emacs-lsp/lsp-ui/
(use-package lsp-ui
  :commands lsp-ui-mode)

;; "Dape is a debug adapter client for Emacs. The debug adapter
;; protocol, much like its more well-known counterpart, the language
;; server protocol, aims to establish a common API for programming
;; tools. However, instead of functionalities such as code
;; completions, it provides a standardized interface for debuggers."
;; https://github.com/svaante/dape
(use-package dape
  :hook
  ((kill-emacs . dape-breakpoint-save)
   (after-init . dape-breakpoint-load)
   (dape-display-source . pulse-momentary-highlight-one-line)
   (dape-start . (lambda () (save-some-buffers t t)))
   (dape-compile . kill-buffer))
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t)
  :config
  (dape-breakpoint-global-mode))

;; "Auto-format source code in many languages with one command"
;; https://github.com/lassik/emacs-format-all-the-code
(use-package format-all
  :bind
  (("<leader> m" . format-all-region-or-buffer))
  :config
  (setq-default format-all-formatters '(("JavaScript" (prettier))
                                        ("HTML" (prettier))
                                        ("CSS" (prettier))
                                        ("Shell" (shfmt)))))

;; "YASnippet is a template system for Emacs. It allows you to type an
;; abbreviation and automatically expand it into function templates."
;; https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

;; "a collection of yasnippet snippets for many languages"
;; https://github.com/AndreaCrotti/yasnippet-snippets
(use-package yasnippet-snippets
  :defer t)

;; ########## Misc ##########

;; "[A] note-taking tool on Emacs. It is similar to emacs-wiki.el; you
;; can enjoy hyperlinks and full-text search easily. It is not similar
;; to emacs-wiki.el; it can be combined with any format."
;; https://github.com/kaorahi/howm
(use-package howm
  :hook
  (((howm-mode after-save) . howm-mode-set-buffer-name)
   (howm-view-summary-mode . (lambda () (jinx-mode -1) (display-line-numbers-mode -1) (visual-fill-column-mode -1))))
  :bind
  (("<leader> h" . howm-menu)
   ;; Remove default global bindings. They conflict with org-mode.
   ("C-c , ," . nil)
   ("C-c , SPC" . nil)
   ("C-c , ." . nil)
   ("C-c , :" . nil)
   ("C-c , C" . nil)
   ("C-c , I" . nil)
   ("C-c , K" . nil)
   ("C-c , M" . nil)
   ("C-c , Q" . nil)
   ("C-c , T" . nil)
   ("C-c , a" . nil)
   ("C-c , b" . nil)
   ("C-c , c" . nil)
   ("C-c , d" . nil)
   ("C-c , e" . nil)
   ("C-c , g" . nil)
   ("C-c , h" . nil)
   ("C-c , i" . nil)
   ("C-c , l" . nil)
   ("C-c , m" . nil)
   ("C-c , o" . nil)
   ("C-c , s" . nil)
   ("C-c , t" . nil)
   ("C-c , w" . nil)
   ("C-c , x" . nil)
   ("C-c , y" . nil)
   ;; By default, howm binds C-h to the same binding as backspace
   :map howm-menu-mode-map
   ("C-h" . nil)
   :map riffle-summary-mode-map
   ("C-h" . nil)
   :map howm-view-contents-mode-map
   ("C-h" . nil))
  :custom
  ;; Use ripgrep as grep
  (howm-view-use-grep t)
  (howm-view-grep-command "rg")
  (howm-view-grep-option "-nH --no-heading --color never")
  (howm-view-grep-extended-option nil)
  (howm-view-grep-fixed-option "-F")
  (howm-view-grep-expr-option nil)
  (howm-view-grep-file-stdin-option nil)
  :init
  (add-to-list 'evil-buffer-regexps '("^\\*howm" . emacs))
  ;; Directory configuration
  (setq howm-directory (expand-file-name "Documents/notes/howm" my/home-directory))
  (setq howm-keyword-file (expand-file-name ".howm-keys" howm-directory))
  (setq howm-history-file (expand-file-name ".howm-history" howm-directory))
  (setq howm-file-name-format "%Y/%Y-%m-%d-%H%M%S.md")
  (setq howm-view-title-header "#"))

;; "Jinx is a fast just-in-time spell-checker for Emacs. Jinx
;; highlights misspelled words in the text of the visible portion of
;; the buffer."
(use-package jinx
  :hook (text-mode prog-mode conf-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_GB es_MX"))

;; "Emacs-libvterm (vterm) is fully-fledged terminal emulator inside GNU Emacs
;; based on libvterm, a C library. As a result of using compiled code (instead
;; of elisp), emacs-libvterm is fully capable, fast, and it can seamlessly
;; handle large outputs."
;; https://github.com/akermu/emacs-libvterm
(use-package vterm
  :hook
  (vterm-mode . (lambda () (setq-local evil-move-cursor-back nil)))
  :bind
  (("<leader> <return>" . vterm)
   (:map vterm-mode-map ("C-q" . vterm-send-next-key)))
  :custom
  (vterm-shell "/bin/zsh")
  :init
  ;; Moving cursor backwards is the default vim behavior but it is not
  ;; appropriate in some cases like terminals.
  (evil-set-initial-state 'vterm-mode 'emacs))

;; "Circe is a Client for IRC in Emacs. It tries to have sane
;; defaults, and integrates well with the rest of the editor, using
;; standard Emacs key bindings and indicating activity in channels in
;; the status bar so it stays out of your way unless you want to use
;; it."
;; https://github.com/emacs-circe/circe
(use-package circe
  :defer t
  :custom
  (circe-network-options
   `(("Libera Chat"
      :tls t
      :nick "tg0xff"
      :sasl-username "tg0xff"
      :sasl-password ,my/secret-libera
      :channels ("#emacs" "#fedora" "#kde" "##rust" "#linux" "#networking" "#security" "#debian" "#cybersecurity" "#audio" "##audio" "##programming" "#bash" "#javascript" "#python"))))
  (circe-reduce-lurker-spam t))

;; ########## UI ##########

;; "Emacs package that displays available keybindings in popup"
;; https://github.com/justbur/emacs-which-key (archived)
(use-package which-key
  :config
  (which-key-mode 1))

;; "[A] small Emacs minor mode that mimics the effect of fill-column
;; in visual-line-mode. Instead of wrapping lines at the window edge,
;; which is the standard behaviour of visual-line-mode, it wraps lines
;; at fill-column (or visual-fill-column-width, if set)."
;; https://codeberg.org/joostkremers/visual-fill-column
(use-package visual-fill-column
  :hook (text-mode)
  :custom
  (visual-fill-column-center-text t)
  (visual-fill-column-extra-text-width '(5 . 5))
  (visual-fill-column-enable-sensible-window-split t))

;; "Enables automatic visibility toggling depending on cursor
;; position. Hidden element parts appear when the cursor enters an
;; element and disappear when it leaves."
;; https://github.com/awth13/org-appear
(use-package org-appear
  :hook (org-mode)
  :custom
  (org-appear-autoentities t)
  (org-appear-autosubmarkers t))

;; https://github.com/protesilaos/ef-themes
(use-package ef-themes
  :config
  (load-theme 'ef-duo-dark))
