;; (load-theme 'monokai :no-confirm)
;; (load-theme 'solarized-light :no-confirm)
;; (load-theme 'solarized-dark :no-confirm)
;; (load-theme 'cyberpunk :no-confirm)

;; (load-theme 'badger :no-confirm)  ;; dark theme based on wombat
(load-theme 'smyx :no-confirm)  ;; dark black/greyish theme
;; (load-theme 'twilight-bright :no-confirm)  ;; light theme
;; (load-theme 'twilight-anti-bright :no-confirm)  ;; dark theme
;; (load-theme 'gruvbox :no-confirm)
;; (load-theme 'leuven :no-confirm)
(load-theme 'darktooth :no-confirm)
;; (load-theme 'ample :no-confirm)  ;; dark theme based on wombat


(setq visible-bell t
      font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)


;; (global-hl-line-mode t)
(tooltip-mode -1)

;; Configure scrolling
(setq scroll-error-top-bottom t   ; Move to beg/end of buffer before signalling an error
      scroll-conservatively 10000 ; Never recenter the screen while scrolling
      scroll-margin 10
      auto-window-vscroll nil)


(defun mw/set-best-font (fonts)
  (when fonts
    (let* ((fontname (car (car fonts)))
           (fontsize (car (last (car fonts))))
           (fontstring (format "%s-%d" fontname fontsize)))
      ;; (message fontstring)
      (if (member fontname (font-family-list)) (set-frame-font fontstring)
        (mw/set-best-font (cdr fonts)))
      )))


(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1)
  (mw/set-best-font '(
                      ("Inconsolata" 18)
                      ("Ubuntu Mono" 18)
                      ("Monaco" 16)
                      ("Fira Mono" 14)
                      ("DejaVu Sans Mono" 14)
                      ("Input Mono" 14)
                      ("Menlo" 14)
                      ("Input Mono Condensed" 14)
                      ("Input Mono Narrow" 14)
                      ("DejaVu Sans Mono" 14)
                      ("monoOne" 14)
                      ("Monospace" 12)
                      ("Source Code Pro" 14)
                      ("Code New Roman" 16)
                      )))
