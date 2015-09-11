;;============================================================
;; Defaults
;;============================================================

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defconst *is-a-mac* (eq system-type 'darwin))

(setq inhibit-startup-message t)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(tooltip-mode -1)
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

;; Don't break lines for me, please
(setq-default truncate-lines t)

;; Don't be so stingy on the memory, we have lots now.
(setq gc-cons-threshold 200000000)

;; No tabs please
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

(setq make-backup-files nil)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)
;; Remove text in active region if inserting text
(delete-selection-mode 1)

(setq echo-keystrokes 0.1)
(setq delete-by-moving-to-trash t)
(set-default 'sentence-end-double-space nil)

;; Real emacs knights don't use shift to mark things
(setq shift-select-mode nil)

(auto-compression-mode t)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Set custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-exists-p custom-file) (load custom-file))

(setenv "WORKON_HOME" (expand-file-name "~/.pyenv/versions"))
(setenv "VIRTUALENVWRAPPER_HOOK_DIR" (expand-file-name "~/.pyenv/versions"))

(defalias 'which 'executable-find)


;;============================================================
;; System
;;============================================================
(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)
  (setq default-input-method "MacOSX")
  ;; Make mouse wheel / trackpad scrolling less jerky
  (setq mouse-wheel-scroll-amount '(1
                                    ((shift) . 5)
                                    ((control))))
  )


;;============================================================
;; Bootstrap
;;============================================================
(if (file-exists-p "~/.cask/cask.el")
    (require 'cask "~/.cask/cask.el")
  (require 'cask "/usr/local/share/emacs/site-lisp/cask.el"))
(cask-initialize)
(require 'pallet)
(pallet-mode t)


;;============================================================
;; Appearance
;;============================================================

(global-hl-line-mode -1)
(global-linum-mode -1)
(blink-cursor-mode -1)

;; (setq font-lock-maximum-decoration nil
;;       truncate-partial-width-windows nil)

;; Scrolling
;; =========================
(setq scroll-error-top-bottom t
      visible-bell t
      scroll-conservatively 10000
      scroll-margin 10
      auto-window-vscroll nil)

;; Themes
;; =========================
(setq color-theme-is-global t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(load-theme 'solarized-dark :no-confirm)
;; (load-theme 'solarized-light :no-confirm)
;; (load-theme 'cyberpunk :no-confirm)
;; (load-theme 'warm-night :no-confirm)
;; (load-theme 'smyx :no-confirm)
;; (load-theme 'noctilux :no-confirm)
;; (load-theme 'monokai :no-confirm)
;; (load-theme 'molokai :no-confirm)
;; (load-theme 'cherry-blossom :no-confirm)
;; (load-theme 'hemisu-dark :no-confirm)
;; (load-theme 'hemisu-ligth :no-confirm)
;; (load-theme 'material :no-confirm)
;; (load-theme 'material-light :no-confirm)
;; (load-theme 'badger :no-confirm)
;; (load-theme 'darktooth :no-confirm)
;; (load-theme 'gruvbox :no-confirm)
;; (load-theme 'flatui :no-confirm)
;; (load-theme 'tango-plus :no-confirm)
;; (load-theme 'flatland-black :no-confirm)
;; (load-theme 'ample :no-confirm)
;; (progn
;;   (require 'moe-theme)
;;   (moe-dark)
;;   (moe-theme-set-color 'green)
;;   )

;; Fonts
;; =========================
(set-frame-font "Droid Sans Mono Dotted-14")
;; (set-frame-font "Cousine-15")
;; (set-frame-font "Inconsolata-16")
;; (set-frame-font "Monaco-14")
;; (set-frame-font "Ubuntu Mono-16")
;; (set-frame-font "Anonymous Pro-16")
;; (set-frame-font "Roboto Mono-15")
;; (set-frame-font "Source Code Pro-14")
;; (set-frame-font "Menlo-14")
;; (set-frame-font "Fantasque Sans Mono-18")
;; (set-face-attribute 'default nil
;;                     :family "Fantasque Sans Mono"
;;                     :height 180
;;                     :weight 'normal
;;                     :width 'normal)
;; (set-face-attribute 'default nil
;;                     :family "Droid Sans Mono"
;;                     :height 140
;;                     :weight 'normal
;;                     :width 'normal)
;; (set-frame-font "Liberation Sans Mono-14:antialias=1")
;; (set-frame-font "Fantasque Sans Mono-16:antialias=1")
;; (set-frame-font "Ubuntu Mono-16:antialias=1")

;;============================================================
;; Loading
;;============================================================

(defun load-local (file)
  (load (expand-file-name file user-emacs-directory)))

(load-local "defuns")
(load-local "vendor/tdd")
;; (load-local "defaults")
;; (load-local "vendor/ido-vertical-mode")


;;============================================================
;; Packages
;;============================================================
(require 'bind-key)
(require 'use-package)


;;#############################
;; Shell
;;#############################
(use-package shell
  :mode (("\\.bash" . shell-script-mode)
         ("\\.zsh" . shell-script-mode)
         ("\\.fish" . shell-script-mode))
  :config
  (when *is-a-mac*
    (use-package exec-path-from-shell
      :config
      (exec-path-from-shell-initialize)
      (exec-path-from-shell-copy-env "PYTHONPATH")))
  )

(use-package dired-x
  :config
  (setq global-auto-revert-non-file-buffers t)
  (setq auto-revert-verbose nil)
  (setq-default dired-omit-files-p t) ; Buffer-local variable
  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^__pycache__$\\|\\.git"))


;;#############################
;; Ace
;;#############################
(use-package ace-jump-mode
  :defer 3
  :bind (("C-c SPC" . ace-jump-mode)
         ("C-c C-SPC" . ace-jump-mode-pop-mark))
  :config
  (setq ace-jump-mode-case-fold t)
  )

(use-package ace-window
  :defer 3
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?q ?w ?e ?r ?a ?s ?d ?f))
  )


;;#############################
;; Git
;;#############################
(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0")
  (defun magit-just-amend ()
    (interactive)
    (save-window-excursion
      (magit-with-refresh
       (shell-command "git --no-pager commit --amend --reuse-message=HEAD"))))
  (setq magit-revert-buffers t)
  (add-hook 'magit-status-mode-hook 'delete-other-windows)
  (bind-key "C-c C-a" 'magit-quit-session magit-status-mode-map)
  (bind-key "q" 'magit-quit-session magit-status-mode-map))

(use-package git-gutter
  :bind (("C-c v =" . git-gutter:popup-hunk) ;; show hunk diff
         ("C-c v p" . git-gutter:previous-hunk)
         ("C-c v n" . git-gutter:next-hunk)
         ("C-c v s" . git-gutter:stage-hunk)
         ("C-c v r" . git-gutter:revert-hunk))
  :diminish git-gutter-mode
  :init
  (global-git-gutter-mode t)
  :config
  (custom-set-variables
   '(git-gutter:window-width 1)
   '(git-gutter:modified-sign "█") ;; two space
   '(git-gutter:added-sign "█")    ;; multiple character is OK
   '(git-gutter:deleted-sign "█"))

  ;; (set-face-background 'git-gutter:modified "purple") ;; background color
  ;; (set-face-background 'git-gutter:added "green")
  ;; (set-face-background 'git-gutter:deleted "red")
  ;; (set-face-foreground 'git-gutter:modified "yellow")
  )

;; (use-package git-gutter-fringe
;;   :init
;;   (git-gutter-mode))

(use-package git-timemachine
  :bind ("C-c v t" . git-timemachine))


;;#############################
;; Navigation
;;#############################
(use-package saveplace
  :config (setq-default save-place t))

(use-package tdd-mode
  :bind ("C-<f5>" . tdd-mode)
  :config
  (shell-command "terminal-notifier -message 'Hello, this is my message' -title 'Message Title'")
  )

(use-package ido
  :defer 3
  :init
  (ido-mode t)
  :config
  (setq ido-case-fold t)
  (setq ido-show-dot-for-dired nil)
  (setq ido-file-extensions-order '(".py" ".rb" ".el" ".js"))
  (add-to-list 'ido-ignore-files '(".DS_Store" ".pyc"))
  (add-to-list 'ido-ignore-directories '("__pycache__", ".git"))
  (use-package ido-vertical-mode
    :config
    ;; (setq ido-vertical-decorations (list
    ;;                                 "\n"
    ;;                                 ""
    ;;                                 "\n"
    ;;                                 "\n..."
    ;;                                 "["
    ;;                                 "]"
    ;;                                 " [No match]"
    ;;                                 " [Matched]"
    ;;                                 " [Not readable]"
    ;;                                 " [Too big]"
    ;;                                 " [Confirm]"
    ;;                                 "\n"
    ;;                                 ""
    ;;                                 ))
    (ido-vertical-mode 1))
  (use-package ido-ubiquitous
    :config
    (ido-ubiquitous-mode t))
  (use-package flx-ido
    :config
    (flx-ido-mode t)))

(use-package visual-regexp
  :bind (("C-s" . vr/isearch-forward)
         ("C-r" . vr/isearch-backward)
         ("C-q" . vr/query-replace))
  )

(use-package projectile
  :defer 1
  :init
  (projectile-global-mode t)
  :config
  (setq projectile-enable-caching t)
  (setq projectile-use-git-grep t)
  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-require-project-root t)
  ;; (setq projectile-completion-system 'grizzl)
  (setq projectile-completion-system 'ido)
  ;; (setq projectile-completion-system 'helm)
  ;; (setq projectile-completion-system 'ivy)
  (add-to-list 'projectile-globally-ignored-files ".DS_Store" "*.pyc")
  (add-to-list 'projectile-globally-ignored-directories "*__pycache__*")
  )

(use-package swiper
  :disabled t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  )

(use-package recentf
  :commands recentf-mode
  :bind ("C-x C-r" . recentf-grizzl-find-file)
  :init
  (recentf-mode 1)
  :config
  (defun recentf-grizzl-find-file ()
    "Find a recent file using Ido."
    (interactive)
    (let ((file (grizzl-completing-read "Choose recent file: " recentf-list)))
      (when file
        (find-file file))))
  (setq recentf-max-saved-items 1000))

(use-package smex
  :bind (("M-x" . smex)
         ("C-x C-m" . smex)))

(use-package helm
  :disabled t
  :init (helm-mode))

(use-package golden-ratio
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode t)
  :config
  ;; (setq golden-ratio-auto-scale t)
  ;; (setq golden-ratio-adjust-factor .2
  ;;     golden-ratio-wide-adjust-factor .2)
  (add-to-list 'golden-ratio-extra-commands 'ace-window)
  (add-to-list 'golden-ratio-extra-commands 'swtich-window)
  )

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


;;#############################
;; Completion
;;#############################
(use-package restclient
  :mode (("\\.rest" . restclient-mode)))


;;#############################
;; Completion
;;#############################
(use-package company
  :diminish company-mode
  :defer 10
  :config
  (global-company-mode))


(use-package guide-key
  :diminish guide-key-mode
  :init (guide-key-mode +1)
  :config
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c p" "C-c m" "C-c C-r")))


;;#############################
;; Editing
;;#############################
(use-package hippie
  :bind ("C-." . hippie-expand))

(use-package swiper
  :disabled t
  :bind (("C-r" . swiper)
         ("C-s" . swiper)))

(use-package drag-stuff
  :defer 5
  :bind (("M-p" . drag-stuff-up)
         ("M-n" . drag-stuff-down)))

(use-package multiple-cursors
  :defer 3
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-w" . mc/mark-all-words-like-this))
  )

(use-package expand-region
  :bind (("C-M-SPC" . er/expand-region)
         ("C-+" . er/contract-region))
  )

(use-package smartparens
  :defer 3
  :diminish smartparens-mode
  :bind (("C-M-k" . sp-kill-sexp-with-a-twist-of-lime)
         ("C-M-f" . sp-forward-sexp)
         ("C-M-b" . sp-backward-sexp)
         ("C-M-n" . sp-up-sexp)
         ("C-M-d" . sp-down-sexp)
         ("C-M-u" . sp-backward-up-sexp)
         ("C-M-p" . sp-backward-down-sexp)
         ("C-M-w" . sp-copy-sexp)
         ("M-s" . sp-splice-sexp)
         ("M-r" . sp-splice-sexp-killing-around)
         ("C-)" . sp-forward-slurp-sexp)
         ("C-}" . sp-forward-barf-sexp)
         ("C-(" . sp-backward-slurp-sexp)
         ("C-{" . sp-backward-barf-sexp)
         ("M-S" . sp-split-sexp)
         ("M-J" . sp-join-sexp)
         ("C-M-t" . sp-transpose-sexp))
  :commands (smartparens-mode show-smartparens-mode)
  :init
  (smartparens-global-mode 1)
  (smartparens-strict-mode 1)
  (show-smartparens-global-mode t)
  (setq smartparens-global-strict-mode t)
  :config (require 'smartparens-config)
  )

(use-package region-bindings-mode
  :defer 5
  :config
  (region-bindings-mode-enable)

  ;; multiple-cursors
  (bind-key "a" 'mc/mark-all-like-this region-bindings-mode-map)
  (bind-key "e" 'mc/edit-lines region-bindings-mode-map)
  (bind-key "p" 'mc/mark-previous-like-this region-bindings-mode-map)
  (bind-key "P" 'mc/unmark-previous-like-this region-bindings-mode-map)
  (bind-key "n" 'mc/mark-next-like-this region-bindings-mode-map)
  (bind-key "N" 'mc/unmark-next-like-this region-bindings-mode-map)

  ;; expand-regions
  (bind-key "f" 'er/mark-defun region-bindings-mode-map)
  (bind-key "u" 'er/mark-url region-bindings-mode-map)
  (bind-key "c" 'er/mark-python-block region-bindings-mode-map)
  (bind-key "m" 'er/mark-method-call region-bindings-mode-map)
  (bind-key "-" 'er/contract-region region-bindings-mode-map)
  (bind-key "+" 'er/expand-region region-bindings-mode-map)
  (bind-key "SPC" 'er/expand-region region-bindings-mode-map)

  (setq region-bindings-mode-disabled-modes '(term-mode))
  (setq region-bindings-mode-disable-predicates
        (list (lambda () buffer-read-only)))
  )

(use-package subword
  :defer 5
  :diminish subword-mode
  :config
  (global-subword-mode 1)
  (defadvice subword-upcase (before upcase-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word)))

  (defadvice subword-downcase (before downcase-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word)))

  (defadvice subword-capitalize (before capitalize-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word))))

(use-package imenu
  :bind ("M-i" . imenu))

(use-package imenu-anywhere
  :bind ("C-M-i" . imenu-anywhere))


;;#############################
;; Modeline
;;#############################
(use-package smart-mode-line
  ;; :disabled t
  :init
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

(use-package powerline
  :disabled t
  :init
  (powerline-default-theme)
  ;; (powerline-center-theme)
  :config
  ;; (setq powerline-display-hud nil)
  (setq powerline-default-separator 'curve)
  )

(use-package re-builder
  :config
  (setq reb-re-syntax 'string)
  )



;;#############################
;; Buffers/Files
;;#############################
(use-package files
  :bind (("C-c R" . rename-this-buffer-and-file)
         ("C-c D" . delete-this-buffer-and-file))
  :config
  (progn
    (setq auto-save-default nil)
    ;; (global-auto-revert-mode 1)
    (setq make-backup-files nil) ; stop creating those backup~ files
    (setq auto-save-default nil) ; stop creating those #autosave# files
    (add-hook 'after-save-hook 'whitespace-cleanup)
    (add-hook 'before-save-hook 'delete-trailing-whitespace)))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))


;;#############################
;; Languages
;;#############################
(use-package web-mode
  :mode (("\\.html\\'" . web-mode)
         ("\\.html\\.erb\\'" . web-mode)
         ("\\.html\\.ejs\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.mustache\\'" . web-mode))
  :config
  (progn
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-engines-alist
          '(("django" . "\\.djhtml")
            ;; ("django" . my-current-buffer-django-p)) ;; set engine to django on django buffer
            ("django" . "templates/.*\\.html")))
    (add-hook 'web-mode-hook
              (lambda ()
                (emmet-mode)))
    (add-hook 'web-mode-hook
              (lambda ()
                (setq web-mode-style-padding 2)
                (setq web-mode-script-padding 2)
                (setq web-mode-markup-indent-offset 2)
                (define-key web-mode-map [(return)] 'newline-and-indent)))))

(use-package jinja2-mode
  :mode (("app/views/.*\\.html" . jinja2-mode)
         (".*\\.jinja" . jinja2-mode)
         (".*\\.jinja2" . jinja2-mode)))

(use-package jade-mode
  :mode ".*\\.jade")

(use-package js2-mode
  :mode "\\.js\\'"
  :interpreter "node"
  :bind (("C-a" . back-to-indentation-or-beginning-of-line)
         ("C-M-h" . backward-kill-word))
  :init
  (progn
    (add-hook 'js2-mode-hook 'smartparens-mode))
  :config
  (progn
    (setq js2-basic-offset 2)
    (bind-key "M-j" 'join-line-or-lines-in-region js2-mode-map)))

(use-package python
  :config
  (bind-key "C-<f9>" 'mw/add-pudb-debug python-mode-map)
  (bind-key "<f9>" 'mw/add-py-debug python-mode-map)
  (add-hook 'python-mode-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

  (use-package eldoc-mode
    :commands (eldoc-mode)
    :init (add-hook 'python-mode-hook 'eldoc-mode)
    :config
    (eval-after-load "eldoc"
      '(diminish 'eldoc-mode))
    )

  (use-package anaconda-mode
    :diminish anaconda-mode
    :init
    (add-hook 'python-mode-hook '(lambda () (anaconda-mode)))
    )

  (use-package pip-requirements
    :mode "\\requirements.txt\\'"
    :config (pip-requirements-mode))
  )

(use-package elpy
  :bind (("C-c t" . elpy-test-django-runner)
         ("C-c C-f" . elpy-find-file)
         ("C-c C-;" . mw/set-django-settings-module))
  :init
  (elpy-enable)
  :config
  (setq elpy-test-runner 'elpy-test-pytest-runner)
  (setq elpy-rpc-backend "jedi")
  ;; (delete 'elpy-module-highlight-indentation elpy-modules)
  ;; (delete 'elpy-module-yasnippet elpy-modules)
  ;; (delete 'elpy-module-flymake elpy-modules)
  (defun mw/set-elpy-test-runners ()
    "Set elpy test runners"
    (let ((python (executable-find "python")))
      (setq
       elpy-test-discover-runner-command (list python "-m" "unittest")
       elpy-test-django-runner-command (list python "manage.py" "test" "--noinput"))))
  (defun mw/auto-activate-virtualenv ()
    "Set auto-activate virtualenv"
    (interactive)
    (let ((virtualenvs (directory-files (getenv "WORKON_HOME"))))
      (message "activating virtualenv")
      (if (and (member (projectile-project-name) virtualenvs) (not (equal (projectile-project-name) pyvenv-virtual-env-name)))
          (progn
            (pyenv-mode t)
            (pyvenv-workon (projectile-project-name))
            (message (format "activated virtualenv: %s" (projectile-project-name))))
        (message "virtualenv not activated"))))
  (use-package pyvenv
    :config
    (defalias 'workon 'pyvenv-workon)
    (add-hook 'python-mode-hook 'pyvenv-mode)
    (add-hook 'projectile-switch-project-hook 'mw/auto-activate-virtualenv)
    (add-hook 'python-mode-hook 'mw/auto-activate-virtualenv)
    ;; (add-hook 'pyvenv-post-activate-hook 'elpy-rpc-restart)
    (add-hook 'pyvenv-post-activate-hooks 'mw/set-elpy-test-runners))

  (defun mw/clean-python-file-hook ()
    "Clean python buffer before saving"
    (interactive)
    (progn
      (if (and (which "autopep8") (symbolp 'elpy-autopep8-fix-code))
          (elpy-autopep8-fix-code))
      ;; (if (symbolp 'elpy-importmagic-fixup)
      ;;     (elpy-importmagic-fixup))
    ))
  (add-hook 'python-mode-hook
          (lambda ()
             (add-hook 'before-save-hook 'mw/clean-python-file-hook nil 'make-it-local)))
  )

(use-package yaml-mode
  :mode ((".*\\.pass" . yaml-mode)
         ("\\.passpierc" . yaml-mode))
  )


;;============================================================
;; Keybindings
;;============================================================

;; Editing
(bind-key "C-c d" 'duplicate-current-line-or-region)
(bind-key "C-j" 'newline-and-indent)
(bind-key "C-c n" 'clean-up-buffer-or-region)
(bind-key "C-M-;" 'comment-or-uncomment-current-line-or-region)
(bind-key "C-a" 'back-to-indentation-or-beginning-of-line)
(bind-key "C-z" 'zap-up-to-char)
(bind-key "C-|" 'align-regexp)

(bind-key "M-j" (λ (join-line -1)))
(bind-key "M-h" 'kill-to-beginning-of-line)
(bind-key "M-g M-g" 'goto-line-with-feedback)
(bind-key "M-<up>" 'open-line-above)
(bind-key "M-<down>" 'open-line-below)

;; Buffer/Files
(bind-key "C-c R" 'rename-this-buffer-and-file)
(bind-key "C-c D" 'delete-this-buffer-and-file)
(bind-key "<f8>" (λ (find-file (f-expand "init.el" user-emacs-directory))))
(bind-key "<f5>" 'recompile)
(bind-key "C-x C-c" (λ (if (y-or-n-p "Quit Emacs? ") (save-buffers-kill-emacs))))

;; Search
(bind-key "C-c g" 'google)
(bind-key "C-c y" 'youtube)

;; Naming
(bind-key "C-c m -" (λ (replace-region-by 's-dashed-words)))
(bind-key "C-c m _" (λ (replace-region-by 's-snake-case)))
(bind-key "C-c m c" (λ (replace-region-by 's-lower-camel-case)))
(bind-key "C-c m C" (λ (replace-region-by 's-upper-camel-case)))
