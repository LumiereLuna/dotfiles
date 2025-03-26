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
  :config
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-mode 1)
  (evil-set-initial-state 'Info-mode 'emacs)
  (evil-set-initial-state 'org-agenda-mode 'emacs)
  (evil-set-initial-state 'dired-mode 'emacs))

;; ########## UX improvements ##########

;; "Consult provides search and navigation commands based on the Emacs
;; completion function completing-read."
;; https://github.com/minad/consult
(use-package consult
  :bind
  (("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-s" . consult-line)
   ("<leader> c f" . consult-fd)
   ("<leader> c r" . consult-ripgrep)
   ("<leader> c o" . consult-outline))
  :custom
  (consult-narrow-key "<")
  (consult-fd-args '((if (executable-find "fdfind" 'remote)
                         "fdfind"
                       "fd")
                     "--full-path --color=never --hidden"))
  (consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob !.git/")
  (consult-preview-key (list :debounce 0.5 'any)))

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

;; "Enhances in-buffer completion with a small completion popup."
;; https://github.com/minad/corfu
(use-package corfu
  :bind
  (:map corfu-map ("C-SPC" . corfu-insert-separator))
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  :init
  (global-corfu-mode))

;; "Corfu uses child frames to display candidates. This makes Corfu
;; unusable on terminal. This package replaces that with popup/popon,
;; which works everywhere."
;; https://codeberg.org/akib/emacs-corfu-terminal
(use-package corfu-terminal
  :init
  (add-hook
   'server-after-make-frame-hook
   (lambda ()
     (if (display-graphic-p)
         (corfu-terminal-mode -1)
       (corfu-terminal-mode 1)))))

;; "Cape provides Completion At Point Extensions which can be used in
;; combination with Corfu, Company or the default completion UI."
;; https://github.com/minad/cape
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file))

;; ########## Programming ##########

;; "Magit is an interface to the version control system Git,
;; implemented as an Emacs package."
;; https://github.com/magit/magit
(use-package magit
  :defer t)

;; "Flycheck is a modern on-the-fly syntax checking extension for GNU
;; Emacs, intended as replacement for the older Flymake extension
;; which is part of GNU Emacs."
;; https://github.com/flycheck/flycheck
(when (not my/android-system-p)
  (use-package flycheck
    :hook (after-init . global-flycheck-mode)))

;; "Client for Language Server Protocol (v3.14). lsp-mode aims to
;; provide IDE-like experience by providing optional integration with
;; the most popular Emacs packages like company, flycheck and
;; projectile."
;; https://github.com/emacs-lsp/lsp-mode
(when (not my/android-system-p)
  (use-package lsp-mode
    :defer t
    :hook
    ((js-mode js-ts-mode python-mode python-ts-mode) . lsp-deferred)
    :custom
    (lsp-keymap-prefix "C-c l")
    (lsp-idle-delay 0.500)
    (lsp-enable-on-type-formatting nil)))

;; "UI integrations for lsp-mode"
;; https://github.com/emacs-lsp/lsp-ui/
(when (not my/android-system-p)
  (use-package lsp-ui
    :defer t
    :bind
    (:map lsp-ui-mode-map
          ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
          ([remap xref-find-references] . lsp-ui-peek-find-references))
    :config
    (evil-define-key 'normal 'lsp-ui-mode-map (kbd "g d") 'lsp-ui-peek-find-definitions)))

;; "YASnippet is a template system for Emacs. It allows you to type an
;; abbreviation and automatically expand it into function templates."
;; https://github.com/joaotavora/yasnippet
(when (not my/android-system-p)
  (use-package yasnippet
    :hook
    (prog-mode . yas-minor-mode)
    :bind
    (:map yas-minor-mode-map
          ("<tab>" . nil)
          ("TAB" . nil))
    :config
    (yas-reload-all)))

;; "a collection of yasnippet snippets for many languages"
;; https://github.com/AndreaCrotti/yasnippet-snippets
(when (not my/android-system-p)
  (use-package yasnippet-snippets
    :defer t))

;; "A simple capf (Completion-At-Point Function) for completing
;; yasnippet snippets."
;; https://github.com/elken/yasnippet-capf
(when (not my/android-system-p)
  (use-package yasnippet-capf
    :hook
    (lsp-after-open . my/completion-lsp-setup)
    :custom
    (yasnippet-capf-lookup-by 'name)
    :init
    (defun my/completion-lsp-setup ()
      (setq-local
       completion-at-point-functions
       (list (cape-capf-super #'lsp-completion-at-point #'yasnippet-capf) t)))))

;; "🌷 Run code formatter on buffer contents without moving point,
;; using RCS patches and dynamic programming."
;; https://github.com/radian-software/apheleia
(when (not my/android-system-p)
  (use-package apheleia
    :defer t
    :bind
    (("<leader> f" . apheleia-format-buffer))))

;; ########## Misc ##########

;; "Unobtrusively trim extraneous white-space *ONLY* in lines edited."
;; https://github.com/lewang/ws-butler
(use-package ws-butler
  :hook (prog-mode text-mode))

;; "[A] note-taking tool on Emacs. It is similar to emacs-wiki.el; you
;; can enjoy hyperlinks and full-text search easily. It is not similar
;; to emacs-wiki.el; it can be combined with any format."
;; https://github.com/kaorahi/howm
(use-package howm
  :preface
  (setq howm-directory (expand-file-name "howm" my/home-directory))
  :if (file-readable-p howm-directory)
  :hook
  (((howm-mode after-save) . howm-mode-set-buffer-name)
   (howm-view-summary-mode . my/howm-view-summary-setup)
   (howm-view-contents-mode . variable-pitch-mode))
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
   ("C-h" . nil)
   :map howm-mode-map
   ("C-c , TAB" . my/insert-section-char)
   ("C-c , K" . my/howm-copy-filename))
  :custom
  ;; Use ripgrep as grep
  (howm-view-use-grep t)
  (howm-view-grep-command "rg")
  (howm-view-grep-option "-nH --no-heading --color never")
  (howm-view-grep-extended-option nil)
  (howm-view-grep-fixed-option "-F")
  (howm-view-grep-expr-option nil)
  (howm-view-grep-file-stdin-option nil)
  (howm-keyword-file (expand-file-name ".howm-keys" howm-directory))
  (howm-history-file (expand-file-name ".howm-history" howm-directory))
  (howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.md")
  :init
  (defun my/howm-view-summary-setup ()
    (display-line-numbers-mode -1)
    (when (bound-and-true-p jinx-mode)
      (jinx-mode -1))
    (when (bound-and-true-p visual-fill-column-mode)
      (visual-fill-column-mode -1)))
  (defun my/insert-section-char ()
    (interactive)
    (self-insert-command 1 ?§))
  (defun my/howm-copy-filename ()
    (interactive)
    (let ((current-prefix-arg 4))
      (call-interactively 'howm-keyword-to-kill-ring)))
  (add-to-list 'evil-buffer-regexps '("^\\*howm" . emacs))
  (setq howm-view-title-header "#")
  :config
  (evil-define-key 'normal 'howm-mode-map (kbd "RET") 'action-lock-magic-return)
  (add-to-list 'howm-excluded-dirs "assets"))

;; "Jinx is a fast just-in-time spell-checker for Emacs. Jinx
;; highlights misspelled words in the text of the visible portion of
;; the buffer."
;; https://github.com/minad/jinx
(when (not my/android-system-p)
  (use-package jinx
    :hook (text-mode prog-mode conf-mode)
    :bind (("M-$" . jinx-correct)
           ("C-M-$" . jinx-languages))
    :custom
    (jinx-languages "en_GB es_MX")))

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
  (visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-fringes-outside-margins nil))

;; https://github.com/protesilaos/ef-themes
(use-package ef-themes
  :custom
  (ef-themes-mixed-fonts t)
  :init
  (defun my/ef-themes-custom-faces ()
    (ef-themes-with-colors
      (custom-set-faces
       `(font-lock-comment-face ((,c :slant normal))))))
  (add-hook 'ef-themes-post-load-hook #'my/ef-themes-custom-faces)
  :config
  (ef-themes-select 'ef-light))
