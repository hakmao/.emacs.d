;;;
;;; JCF's init.el
;;;

;; Start an Emacs server
(server-start)

;; Don't show startup screen
(setq inhibit-startup-message t)

;; Set desired modes
(setq column-number-mode t)
(global-display-line-numbers-mode)
(show-paren-mode 1)
(save-place-mode 1)
(global-hl-line-mode t) ; Highlight current line

;; We want newlines at the end of the file
(setq require-final-newline 1)

;; Use 'command' key as 'meta' in Mac OS
(setq mac-command-modifier 'meta)

;; Remove unwanted modes (tool bar, menu bar, and scroll bar)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

;;;;;;;;;;;;;;;;
;;; Packages ;;;
;;;;;;;;;;;;;;;;

;; Package Management
(require 'package)
(setq package-enable-at-startup nil)
;; Add MELPA to package archives 
(add-to-list 'package-archives
	     '("melpa" .  "https://melpa.org/packages/"))

;; Initialise --don't remove!
(package-initialize)

;; Packages to install by default
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Individual packages

;; which-key
(use-package which-key
  :ensure t
  :init
  (which-key-mode 1))

;; Theme
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init 
  (setq spacemacs-theme-comment-bg nil)
  (setq spacemacs-theme-comment-italic +1)
  (load-theme 'spacemacs-dark +1)) 

;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline 1))

;; (use-package nyan-mode
;;   :ensure t
;;   :init (nyan-mode))

(use-package beacon
  :ensure t
  :config (beacon-mode 1))

(use-package winner
  :init (winner-mode t))

(use-package rainbow-delimiters
  :ensure t
  :init
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

;; Git integration
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;;; Programming ;;;

;; Better handling of parentheses when editing Lisp(s)
(use-package paredit
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  :config
  (show-paren-mode t)
  :bind (("M-[" . paredit-wrap-square)
	 ("M-{" . paredit-wrap-curly))
  :diminish nil)

;; Company
(use-package company
  :defer t
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous)
	      ("C-d" . company-show-doc-buffer)
	      ("M-." . company-show-location))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(use-package slime-company
  :ensure t
  :defer t)

(use-package slime
  :ensure t
  :bind (("M-TAB" . company-complete)
	 ("C-c C-d C-s" . slime-describe-symbol)
	 ("C-c C-d C-f" . slime-describe-function))
  :init
  (setq slime-lisp-implementations '((sbcl ("sbcl")))
	slime-default-lisp 'sbcl)
  (setq common-lisp-hyperspec-root "/usr/local/share/doc/hyperspec/HyperSpec/")
  (setq common-lisp-hyperspec-symbol-table (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
  (setq common-lisp-hyperspec-issuex-table (concat common-lisp-hyperspec-root "Data/Map_IssX.txt"))
  (slime-setup '(slime-fancy slime-company slime-cl-indent)))

(defun slime-description-fontify ()
   (with-current-buffer "*slime-description*" (slime-company-doc-mode)))

(defadvice slime-show-description (after slime-description-fontify activate)
  "Fontify sections of SLIME description."
  (slime-description-fontify))

;; (eval-after-load "slime"
;;   '(progn
;;      (setq common-lisp-hyperspec-root
;;            "/usr/local/share/doc/hyperspec/HyperSpec/")
;;      (setq common-lisp-hyperspec-symbol-table
;;            (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
;;      (setq common-lisp-hyperspec-issuex-table
;;            (concat common-lisp-hyperspec-root "Data/Map_IssX.txt"))))

(use-package go-eldoc
  :ensure t
  :defer t)

;; Golang
(use-package go-mode
  :ensure t
  :init
  (progn
    (setq gofmt-command "goimports")
    (setq indent-tabs-mode t)
    (add-hook 'go-mode-hook 'go-eldoc-setup)
    (add-hook 'before-save-hook 'gofmt-before-save)))

;; TypeScript
(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
	 (typescript-mode . tide-hl-identifier-mode)
	 (before-save . tide-format-before-save)))

;; Frame size and placement
(if (display-graphic-p) ; check whether we are running in a graphical environment
    (progn
      (setq initial-frame-alist ; settings for first window
	    '(
	      (tool-bar-lines . 0)
	      (width . 130) ; chars
	      (height . 400) ; lines
	      (left . 1300)
	      (top . 5)))
      (setq default-frame-alist ; settings for any subsequent new windows
	    '(
	      (tool-bar-lines . 0)
	      (width . 130)
	      (height . 400)
	      (left . 1300)
	      (top . 5))))
  (progn
    (setq initial-frame-alist '( (tool-bar-lines . 0)))
    (setq default-frame-alist '( (tool-bar-lines . 0)))))

    
;;(setq frame-resize-pixelwise t)
;;(set-frame-position (selected-frame) 1450 0)
;;(set-frame-size (selected-frame) 120 80)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 148 :width normal :foundry "nil" :family "Menlo")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-eldoc rainbow-delimiters beacon slime-company paredit magit which-key use-package tide spacemacs-theme nyan-mode moom doom-modeline company))))
