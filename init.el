;;; init.el - Edited -*- lexical-binding: t; -*-

(mapc
 (lambda (mode)
   (when (fboundp mode)
     (funcall mode -1)))
 '(menu-bar-mode tool-bar-mode scroll-bar-mode))

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)

(require 's)
(require 'f)
(require 'ht)
(require 'git)
(require 'ert)
(require 'use-package)

(setq default-directory (f-full (getenv "HOME")))

(defun load-local (file)
  (load (f-expand file user-emacs-directory)))

(load-local "defuns")
(load-local "misc")
(when (eq system-type 'darwin)
  (load-local "osx"))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on) ;; handle shell colours


;;;; Appearance:

(load-theme 'cyberpunk :no-confirm)

(setq visible-bell t
      font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1))

(add-hook 'emacs-lisp-mode-hook
          (lambda()
            (setq mode-name "el")))

(add-hook 'projectile-mode-hook
          (lambda()
            (setq mode-name "pj")))

;;;; Packages

(use-package hl-line
  :config (set-face-background 'hl-line "#073642"))

(use-package dash
  :config (dash-enable-font-lock))

(use-package dired-x)

(use-package ido
  :init (ido-mode 1)
  :config
  (progn
    (setq ido-case-fold t)
    (setq ido-everywhere t)
    (setq ido-enable-prefix nil)
    (setq ido-enable-flex-matching t)
    (setq ido-create-new-buffer 'always)
    (setq ido-max-prospects 10)
    (setq ido-file-extensions-order '(".rb" ".el" ".coffee" ".js"))
    (add-to-list 'ido-ignore-files "\\.DS_Store")))

(use-package nyan-mode
  :init (nyan-mode 1))

(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-c C-w" . mc/mark-all-words-like-this)
         ("C-c C-s" . mc/mark-all-symbols-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)))

(use-package popwin
  :config (setq display-buffer-function 'popwin:display-buffer))

(use-package projectile
  :init (projectile-global-mode 1)
  :config
  (progn
    (setq projectile-enable-caching t)
    (setq projectile-require-project-root nil)
    (setq projectile-completion-system 'ido)
    (add-to-list 'projectile-globally-ignored-files ".DS_Store")))

(use-package projectile-rails
  :init (add-hook 'projectile-mode-hook 'projectile-rails-on))

(use-package drag-stuff
  :init (drag-stuff-global-mode 1))

(use-package misc
  :bind ("M-z" . zap-up-to-char))

(use-package magit
  :init
  (progn
    (use-package magit-blame)
    (bind-key "C-c C-a" 'magit-just-amend magit-mode-map))
  :config
  (progn
    (setq magit-default-tracking-name-function 'magit-default-tracking-name-branch-only)
    (setq magit-set-upstream-on-push t)
    (setq magit-completing-read-function 'magit-ido-completing-read)
    (setq magit-stage-all-confirm nil)
    (setq magit-unstage-all-confirm nil)
    (setq magit-restore-window-configuration t)
    (add-hook 'magit-mode-hook 'rinari-launch))
  :bind ("C-x g" . magit-status))

(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C-\\" . er/expand-region)
         ("C-|" . er/contract-region)))

(use-package cua-base
  :init (cua-mode 1)
  :config
  (progn
    (setq cua-enable-cua-keys nil)
    (setq cua-toggle-set-mark nil)))

(use-package uniquify
  :config (setq uniquify-buffer-name-style 'forward))

(use-package saveplace
  :config (setq-default save-place t))

(use-package windmove
  :config (windmove-default-keybindings 'shift))

(use-package ctags-update
  :config (add-hook 'projectile-rails-mode-hook  'turn-on-ctags-auto-update-mode))

(use-package ruby-mode
  :init
  (progn
    (use-package rvm
      :init (rvm-use-default)
      :config (setq rvm-verbose nil))
    (use-package ruby-tools)
    (use-package rhtml-mode
      :mode (("\\.rhtml$" . rhtml-mode)
             ("\\.html\\.erb$" . rhtml-mode)))
    (use-package rinari
      :init (global-rinari-mode 1)
      :config
      (progn
        (setq ruby-insert-encoding-magic-comment nil)
        (setq rinari-tags-file-name "TAGS")))
    (use-package rspec-mode
      :config
      (progn
        (setq rspec-use-rvm t)
        (setq rspec-use-rake-flag nil)
        (defadvice rspec-compile (around rspec-compile-around activate)
          "Use BASH shell for running the specs because of ZSH issues."
          (let ((shell-file-name "/bin/bash"))
            ad-do-it)))))
  :config
  (progn
    (add-hook 'ruby-mode-hook 'rvm-activate-corresponding-ruby)
    (setq ruby-deep-indent-paren nil))
  :bind (("C-M-h" . backward-kill-word)
         ("C-M-n" . scroll-up-five)
         ("C-M-p" . scroll-down-five))
  :mode (("\\.rake$" . ruby-mode)
         ("\\.gemspec$" . ruby-mode)
         ("\\.ru$" . ruby-mode)
         ("Rakefile$" . ruby-mode)
         ("Gemfile$" . ruby-mode)
         ("Capfile$" . ruby-mode)
         ("Guardfile$" . ruby-mode)))

(use-package ruby-test-mode
  :bind ("C-c C-t" . ruby-test-run-at-point))

(use-package robe
  :config (add-hook 'ruby-mode-hook 'robe-mode))

(use-package rbenv
  :init (global-rbenv-mode))

(use-package sublimity
  :config
  (progn
    (sublimity-mode)
    (sublimity-scroll)))

(use-package markdown-mode
  :config
  (progn
    (bind-key "M-n" 'open-line-below markdown-mode-map)
    (bind-key "M-p" 'open-line-above markdown-mode-map))
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$" . markdown-mode)))

(use-package smartparens
  :init
  (progn
    (use-package smartparens-config)
    (use-package smartparens-ruby)
    (use-package smartparens-html)
    (smartparens-global-mode 1)
    (show-smartparens-global-mode 1))
  :config
  (progn
    (setq smartparens-strict-mode t)
    (setq sp-autoescape-string-quote nil)
    (setq sp-autoinsert-if-followed-by-word t)
    (sp-local-pair 'emacs-lisp-mode "`" nil :when '(sp-in-string-p)))
  :bind
  (("C-M-k" . sp-kill-sexp-with-a-twist-of-lime)
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
   ("C-M-t" . sp-transpose-sexp)))

(use-package flycheck
  :config
  (progn
    (setq flycheck-display-errors-function nil)
    (add-hook 'after-init-hook 'global-flycheck-mode)))

(use-package flycheck-cask
  :init (add-hook 'flycheck-mode-hook 'flycheck-cask-setup))

(use-package yasnippet
  :init
  (progn
    (use-package yasnippets)
    (yas-global-mode 1)
    (setq-default yas/prompt-functions '(yas/ido-prompt))))

(use-package yaml-mode
  :mode ("\\.yml$" . yaml-mode))

(use-package feature-mode
  :mode ("\\.feature$" . feature-mode)
  :config
  (add-hook 'feature-mode-hook
            (lambda ()
              (electric-indent-mode -1))))

(use-package cc-mode
  :config
  (progn
    (add-hook 'c-mode-hook (lambda () (c-set-style "bsd")))
    (add-hook 'java-mode-hook (lambda () (c-set-style "bsd")))
    (setq tab-width 2)
    (setq c-basic-offset 2)))

(use-package css-mode
  :config (setq css-indent-offset 2))

(use-package js-mode
  :mode ("\\.json$" . js-mode)
  :init
  (progn
    (add-hook 'js-mode-hook (lambda () (setq js-indent-level 2)))))

(use-package js2-mode
  :mode (("\\.js$" . js2-mode)
         ("Jakefile$" . js2-mode))
  :interpreter ("node" . js2-mode)
  :bind (("C-a" . back-to-indentation-or-beginning-of-line)
         ("C-M-h" . backward-kill-word))
  :config
  (progn
    (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))
    (add-hook 'js2-mode-hook (lambda ()
                               (bind-key "M-j" 'join-line-or-lines-in-region js2-mode-map)))))

(use-package coffee-mode
  :config
  (progn
    (add-hook 'coffee-mode-hook
              (lambda ()
                (bind-key "C-j" 'coffee-newline-and-indent coffee-mode-map)
                (bind-key "C-M-h" 'backward-kill-word coffee-mode-map)
                (setq coffee-tab-width 2)
                (setq coffee-cleanup-whitespace nil)))))

(use-package nvm)

(use-package sh-script
  :config (setq sh-basic-offset 2))

(use-package emacs-lisp-mode
  :init
  (progn
    (use-package eldoc
      :init (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode))
    (use-package macrostep
      :bind ("C-c e" . macrostep-expand))
    (use-package ert
      :config (add-to-list 'emacs-lisp-mode-hook 'ert--activate-font-lock-keywords)))
  :bind (("M-&" . lisp-complete-symbol)
         ("M-." . find-function-at-point))
  :interpreter (("emacs" . emacs-lisp-mode))
  :mode ("Cask" . emacs-lisp-mode))

(use-package html-script-src)

(use-package haml-mode)
(use-package sass-mode)

(use-package eshell
  :init
  (add-hook 'eshell-first-time-mode-hook
            (lambda ()
              (add-to-list 'eshell-visual-commands "htop")))
  :config
  (progn
    (setq eshell-history-size 5000)
    (setq eshell-save-history-on-exit t)))

(use-package flx-ido
  :init (flx-ido-mode 1)
  :config (setq ido-use-face nil))

(use-package ido-vertical-mode
  :init (ido-vertical-mode 1))

(use-package ido-ubiquitous
  :init (ido-ubiquitous-mode 1))

(use-package puppet-mode)

(use-package web-mode
  :init (progn
          (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
  :config (progn
            (add-hook 'web-mode-hook
                      (lambda ()
                        (setq web-mode-style-padding 2)
                        (setq web-mode-script-padding 2)))))

(use-package ert-async
  :config (add-to-list 'emacs-lisp-mode-hook 'ert-async-activate-font-lock-keywords))

(use-package ibuffer
  :config (setq ibuffer-expert t)
  :bind ("C-x C-b" . ibuffer))

(use-package cl-lib-highlight
  :init (cl-lib-highlight-initialize))

(use-package idomenu
  :bind ("M-i" . idomenu))

(use-package auto-complete
  :init (global-auto-complete-mode t))

(use-package httprepl)

(use-package ack-and-a-half)

(use-package swoop
  :bind ("C-o" . swoop))

(use-package ag)

(use-package git-gutter+
  :init (global-git-gutter+-mode t))

(use-package visual-regexp
  :init (use-package visual-regexp-steroids)
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark)
         ("C-r" . vr/isearch-backward)
         ("C-s" . vr/isearch-forward)))


(use-package diminish
  :init
  (progn
    (eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
    (eval-after-load "eldoc" '(diminish 'eldoc-mode))
    (eval-after-load "smartparens" '(diminish 'smartparens-mode))
    (eval-after-load "git-gutter+" '(diminish 'git-gutter+-mode))
    (eval-after-load "guide-key" '(diminish 'guide-key-mode))
    (eval-after-load "magit" '(diminish 'magit-auto-revert-mode))))

;;;; Custom packages

(load-local "shoulda")

;;;; Bindings

(bind-key "<f8>" (λ (find-file (f-expand "init.el" user-emacs-directory))))
(bind-key "<f6>" 'linum-mode)

(bind-key "C-a" 'back-to-indentation-or-beginning-of-line)
(bind-key "C-;" 'comment-or-uncomment-current-line-or-region)
(bind-key "C-v" 'scroll-up-five)
(bind-key "M-v" 'scroll-down-five)
(bind-key "C-j" 'newline-and-indent)

(bind-key "M-g" 'goto-line)
(bind-key "M-n" 'drag-stuff-down)
(bind-key "M-p" 'drag-stuff-up)
(bind-key "M-j" 'join-line-or-lines-in-region)
(bind-key "M-k" 'kill-this-buffer)
(bind-key "M-o" 'other-window)
(bind-key "M-1" 'delete-other-windows)
(bind-key "M-2" 'split-window-below)
(bind-key "M-3" 'split-window-right)
(bind-key "M-0" 'delete-window)
(bind-key "M-}" 'next-buffer)
(bind-key "M-{" 'previous-buffer)
(bind-key "M-`" 'other-frame)
(bind-key "M-w" 'kill-region-or-thing-at-point)

(bind-key "M-+" 'text-scale-increase)
(bind-key "M-_" 'text-scale-decrease)

(bind-key "M-j" (lambda () (interactive) (join-line -1)))

(bind-key "C-c g" 'google)
(bind-key "C-c d" 'duplicate-current-line-or-region)
(bind-key "C-c n" 'clean-up-buffer-or-region)
(bind-key "C-c s" 'swap-windows)
(bind-key "C-c C-r" 'rename-this-buffer-and-file)
(bind-key "C-c C-k" 'delete-this-buffer-and-file)

(bind-key "C-M-h" 'backward-kill-word)

(bind-key
 "C-x C-c"
 (lambda ()
   (interactive)
   (if (y-or-n-p "Quit Emacs? ")
       (save-buffers-kill-emacs))))

;; Other keybindings
;; (bind-key "M-." 'find-tag)
(bind-key "C-c t s" 'shoulda:run-should-at-point)
(bind-key "C-c t c" 'shoulda:run-context-at-point)
(bind-key "C-c t b" 'ruby-test-run)
(define-key 'help-command "R" 'yari)

(global-unset-key (kbd "C-x +")) ;; used to be balance-windows
(bind-key "C-x + -" (λ (replace-region-by 's-dashed-words)))
(bind-key "C-x + _" (λ (replace-region-by 's-snake-case)))
(bind-key "C-x + c" (λ (replace-region-by 's-lower-camel-case)))
(bind-key "C-x + C" (λ (replace-region-by 's-upper-camel-case)))

;;;; Sandbox

(let ((sandbox-path (f-expand "sandbox" user-emacs-directory)))
  (when (f-dir? sandbox-path)
    (-each (f--files sandbox-path (f-ext? it "el")) 'load)))

;;;; End
