;; -*- mode: emacs-lisp -*-



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   '("a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" default))
 '(display-time-mode t)
 '(package-selected-packages
   '(markdown-mode ag cargo flycheck-rust rust-mode rust-playground sql-indent elixir-mode tide company-erlang company rjsx-mode typescript-mode dockerfile-mode graphviz-dot-mode go-mode exec-path-from-shell magit-gitflow magit alect-themes flycheck yaml-mode web-mode git erlang))
 '(safe-local-variable-values
   '((vc-prepare-patches-separately)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")
     (allout-layout . t)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq large-file-warning-threshold 100000000)

(setq confirm-kill-emacs 'y-or-n-p)


(when (and (equal emacs-version "27.2")
          (eql system-type 'darwin))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(toggle-frame-fullscreen)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
               '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
  (package-initialize)

  (unless package-archive-contents
    (package-refresh-contents))

  (dolist (package package-selected-packages)
    (unless (package-installed-p package)
      (package-install package))))

(cond
 ((eq system-type 'darwin)
  (load-theme 'alect-dark t)
    (setq dired-use-ls-dired t
        insert-directory-program "/usr/local/bin/gls"
        dired-listing-switches "-aBhl --group-directories-first")
    (setq ns-alternate-modifier 'meta)
    (setq ns-right-alternate-modifier 'none)
    (setq ns-command-modifier 'super)
    (setq ns-right-command-modifier 'left)
    (setq ns-control-modifier 'control)
    (setq ns-right-control-modifier 'left)
    (setq ns-function-modifier 'none))
  ((eq system-type 'windows-nt)
    (setq w32-pass-lwindow-to-system nil)
    (setq w32-pass-rwindow-to-system nil)
    (setq w32-lwindow-modifier 'super)
    (setq w32-rwindow-modifier 'super)))

;;(global-set-key (kbd "M-3") '(lambda() (interactive) (insert-string "#")))

(set-face-attribute 'default nil :font "-apple-Monaco-medium-normal-normal-*-24-*-*-*-m-0-iso10646-1")
(require 'git)
(require 'magit)
(require 'magit-gitflow)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(add-to-list 'exec-path "/usr/local/bin")

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(setq display-time-24hr-format t)
(display-time)

(require 'erlang-start)
(require 'erlang-flymake)

(erlang-flymake-only-on-save)

(put 'downcase-region 'disabled nil)
(setq-default indent-tabs-mode nil)
(column-number-mode)

(setq scroll-step 1)

;; (global-whitespace-mode 1)
(put 'upcase-region 'disabled nil)
(setq whitespace-global-modes '(not org-mode markdown-mode dired))
(setq whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark missing-newline-at-eof))

(setq vc-follow-symlinks t)

;(global-flycheck-mode)

;(add-hook 'after-init-hook 'global-flycheck-mode)
;; (setq flycheck-display-errors-function nil
;;       flycheck-erlang-include-path '("../include" "deps/*/include")
;;       flycheck-erlang-library-path '()
;;       flycheck-check-syntax-automatically '(idle-change))

;;(add-hook 'after-init-hook 'global-company-mode)


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point-max)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
;  (flycheck-mode +1)
;  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
; (flycheck-add-mode 'typescript-tslint 'web-mode)
