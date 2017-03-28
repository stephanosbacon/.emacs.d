
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("MELPA Stable" . "http://stable.melpa.org/packages/") t)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; C-x g
(global-set-key [24 103] (quote goto-line))

(setq inhibit-startup-message t)
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset 2)
(setq js-indent-level 2)

(setq ring-bell-function 'ignore)

;; default/sebsequent window
(setq default-frame-alist
      '(
        (width . 180) ; character
        (height . 55) ; lines
        ))


;;; Go stuff

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))


;;;; Go support
;;;;
(setenv "GOPATH" "/Users/sbacon/gospace")
(add-to-list 'exec-path "/Users/sbacon/gospace/bin")
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet"))
  ; Go oracle
  (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)
(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)
(with-eval-after-load 'go-mode
   (require 'go-autocomplete))


;;;; javascript mode
;;;;
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq-default js2-global-externs
              '("module" "require" "buster" "sinon" "assert" "refute" "setTimeout"
                "clearTimeout" "setInterval" "clearInterval" "location" "__dirname"
                "console" "JSON" "include" "process" "Buffer"))

;(setq js-doc-mail-address "your email address"
;       js-doc-author (format "your name <%s>" js-doc-mail-address)
;       js-doc-url "url of your website"
;       js-doc-license "license name")

(eval-after-load 'js2-mode
  (add-hook 'js2-mode-hook
           #'(lambda ()
               (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
               (define-key js2-mode-map "@" 'js-doc-insert-tag))))


(add-to-list 'load-path "~/.emacs.d/gitrepos/tern/emacs");
(autoload 'tern-mode "tern.el" nil t)

(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (auto-complete-mode 1)
      (tern-ac-setup)))

