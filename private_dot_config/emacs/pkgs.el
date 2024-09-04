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
  (evil-mode 1))

;; "This is a collection of Evil bindings for the parts of Emacs that Evil does
;; not cover properly by default, such as help-mode, M-x calendar, Eshell and
;; more."
;; https://github.com/emacs-evil/evil-collection
(use-package evil-collection
  :config
  (delete 'vterm evil-collection-mode-list)
  (evil-collection-init))

;; "Supplemental evil-mode key-bindings to Emacs org-mode."
;; https://github.com/Somelauw/evil-org-mode
(use-package evil-org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; ########## Org-mode ##########

;; https://orgmode.org/
;; https://git.savannah.gnu.org/cgit/emacs/org-mode.git
(use-package org
  :ensure nil
  :hook
  (org-mode . variable-pitch-mode)
  (org-todo-repeat . org-reset-checkbox-state-subtree)
  (after-init . (lambda () (find-file (concat org-directory "/*.org") t)))
  :custom-face
  (org-checkbox ((t (:inherit fixed-pitch))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit fixed-pitch))))
  :custom
  (org-directory `,(expand-file-name "Documents/org" my/home-directory))
  (org-agenda-files `(,org-directory))
  (org-capture-templates '(("d" "default"
                            entry (file+headline "todo.org" "Inbox")
                            "* TODO %?" :prepend t)))
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)")))
  (org-agenda-window-setup 'other-tab)
  (org-agenda-tags-column 0)
  (org-agenda-current-time-string "◀── now ─────────────────────────────────────────────────")
  (org-M-RET-may-split-line nil)
  (org-ellipsis "   […]")
  (org-tags-column 0)
  (org-log-done 'time)
  (org-preview-latex-image-directory `,(expand-file-name "org-latex-preview" temporary-file-directory))
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-image-actual-width '(400))
  (org-agenda-custom-commands '(("n" todo "NEXT"
                                 ((org-agenda-sorting-strategy '(category-up priority-up))))))
  :config
  (defvar-keymap my/org-major-mode-keymap
    :doc "My prefix map for org's major mode."
    "m" #'my/org-sort-media
    "t" #'my/org-sort-todo
    "i" #'org-id-get-create)
  (defvar-keymap my/org-mode-keymap
    :doc "My prefix map for org's global commands."
    "a" #'org-agenda
    "c" #'org-capture
    "l" #'org-store-link)
  (keymap-set global-map "<leader> o" my/org-mode-keymap)
  (keymap-set org-mode-map "<leader> ." my/org-major-mode-keymap)
  (defun my/org-sort-media ()
    (interactive)
    (org-sort-entries nil ?a)
    (org-sort-entries nil ?p)
    (org-sort-entries nil ?o))
  (defun my/org-sort-todo ()
    (interactive)
    (org-sort-entries nil ?p)
    (org-sort-entries nil ?o)))

;; "Enables automatic visibility toggling depending on cursor
;; position. Hidden element parts appear when the cursor enters an
;; element and disappear when it leaves."
;; https://github.com/awth13/org-appear
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoentities t)
  (org-appear-autosubmarkers t))

;; "Org-roam is a plain-text knowledge management system. It brings
;; some of Roam's more powerful features into the Org-mode ecosystem."
;; https://github.com/org-roam/org-roam
(use-package org-roam
  :custom
  (org-roam-directory `,(expand-file-name "Documents/org-roam" my/home-directory))
  (org-roam-node-display-template "${title} ${tags}")
  :config
  (defun my/org-roam-open-day-file ()
    (interactive)
    (find-file
     (concat org-roam-directory "/notes/" (format-time-string "%Y-%m-%d") ".org")))
  (defvar-keymap my/org-roam-mode-keymap
    :doc "My prefix map for roam's commands."
    "f" #'org-roam-node-find
    "i" #'org-roam-node-insert
    "b" #'org-roam-buffer-toggle
    "a" #'org-roam-alias-add
    "t" #'org-roam-tag-add
    "d" #'my/org-roam-open-day-file)
  (keymap-set global-map "<leader> r" my/org-roam-mode-keymap)
  (custom-set-variables '(org-cite-global-bibliography `(,(expand-file-name "library.bib" org-roam-directory))))
  ;; Customise the appearance of org-roam-buffer.
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (slot . 0)
                 (window-width . 0.20)
                 (preserve-size '(t . t))
                 (window-parameters . ((no-delete-other-windows . t)))))
  (org-roam-db-autosync-mode))

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
  :config
  (ws-butler-global-mode 1))

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

;; "Jinx is a fast just-in-time spell-checker for Emacs. Jinx
;; highlights misspelled words in the text of the visible portion of
;; the buffer."
(use-package jinx
  :hook (text-mode prog-mode conf-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_GB es_MX"))

;; ########## UI ##########

;; "Emacs package that displays available keybindings in popup"
;; https://github.com/justbur/emacs-which-key (archived)
(use-package which-key
  :config
  (which-key-mode 1))

;; "[A] "rainbow parentheses"-like mode which highlights delimiters such
;; as parentheses, brackets or braces according to their depth."
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :hook (lisp-mode emacs-lisp-mode))

;; https://git.sr.ht/~protesilaos/modus-themes
(use-package modus-themes
  :if (or (display-graphic-p) (daemonp))
  :custom-face
  (font-lock-keyword-face ((t (:weight bold))))
  :custom
  (modus-themes-org-blocks 'tinted-background)
  ;; Cyberpunk-inspired colourscheme.
  (modus-vivendi-palette-overrides '((fg-main "#dddddd")
                                     (bg-main "#04000d")
                                     (bg-hl-line bg-magenta-nuanced)
                                     ;; Semantic palette.
                                     (comment-colour "#e0c304")
                                     (string-colour "#04d2e0")
                                     (function-colour "#e00488")))
  ;; White colourscheme.
  (modus-operandi-palette-overrides '((fg-main "#1c1c1c")
                                      (bg-hl-line bg-magenta-nuanced)
                                      (comment-colour "#c3000d")
                                      (string-colour "#00725d")
                                      (function-colour "#bf00c5")))
  (modus-themes-common-palette-overrides '((bg-region bg-cyan-subtle)
                                           (bg-tab-current bg-main)
                                           (modeline-colour fg-main)
                                           ;; --- Semantic highlighting ---
                                           (border-mode-line-active modeline-colour)
                                           (comment comment-colour)
                                           (docstring comment-colour)
                                           (keyword keyword-colour)
                                           (prose-code string-colour)
                                           (prose-verbatim string-colour)
                                           (string string-colour)
                                           (fnname function-colour)
                                           ;; --- Monochrome ---
                                           (bg-fringe unspecified)
                                           (bg-line-number-active bg-main)
                                           (bg-line-number-inactive bg-main)
                                           (bg-mode-line-active bg-main)
                                           (builtin fg-main)
                                           (constant fg-main)
                                           (date-common fg-main)
                                           (date-deadline fg-main)
                                           (date-event fg-main)
                                           (date-holiday fg-main)
                                           (date-now fg-main)
                                           (date-scheduled fg-main)
                                           (date-weekday fg-main)
                                           (date-weekend fg-main)
                                           (fg-alt fg-main)
                                           (fg-fringe unspecified)
                                           (fg-heading-0 fg-main)
                                           (fg-heading-1 fg-main)
                                           (fg-heading-2 fg-main)
                                           (fg-heading-3 fg-main)
                                           (fg-heading-4 fg-main)
                                           (fg-heading-5 fg-main)
                                           (fg-heading-6 fg-main)
                                           (fg-heading-7 fg-main)
                                           (fg-heading-8 fg-main)
                                           (fg-mode-line-active fg-main)
                                           (fg-region unspecified)
                                           (fringe unspecified)
                                           (identifier fg-main)
                                           (preprocessor fg-main)
                                           (prose-metadata fg-main)
                                           (prose-metadata-value fg-main)
                                           (prose-table fg-main)
                                           (prose-tag fg-main)
                                           (rx-backslash fg-main)
                                           (rx-construct fg-main)
                                           (type fg-main)
                                           (variable fg-main)
                                           (warning fg-main)))
  :config
  (load-theme 'modus-vivendi))
