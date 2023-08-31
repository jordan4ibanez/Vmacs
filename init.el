;; A friendly terminal welcome. :)
(print "Welcome to Vmacs!" #'external-debugging-output)

;; I hope the user followed the directions or this ain't gonna work. :T
(add-to-list 'load-path "~/.emacs.d/vmacs/")

;; Enable MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Turn off the startup message (for now).
(setq inhibit-startup-message t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Ensure these are enabled.
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode 1)

;; Display line numbers in every buffer.
(line-number-mode 1)
(global-display-line-numbers-mode 1)

;; Stop the mouse scroll wheel from going crazy.
(setq mouse-wheel-progressive-speed nil)
;; Use default VSCode/Pulsar scrolling
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil)))

;; Make the cursor actually usable. [] -> |
(setq-default cursor-type 'bar)

;; Make pasting/selection overwrite work like normal.
;; FIXME: Think needs: https://www.gnu.org/software/emacs/manual/html_node/emacs/CUA-Bindings.html
(delete-selection-mode 1)

;; Automatically maximize Vmacs.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Set the window title. https://emacs.stackexchange.com/a/46016
;; So all this is doing is building a string based on expressions!
(setq frame-title-format
    `((buffer-file-name "%b - ")
      "Vmacs"))

;; We gotta start with the theme maaaan. Doom-one is the absolute nicest out there.

(let ((cool-file "DOOMED.vmacs"))
  (if (not (file-exists-p cool-file))
      (progn
        (write-region "" "" cool-file)
        (package-install 'doom-themes))
    (print "DOOM theme already installed, nice. 8)" #'external-debugging-output)))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Stop Vmacs from scaring the poop out of someone.
;; Disable all bell features. (flashing, beeping)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)


;; Testing sublimity
;;! This causes weird issues!

; (package-install 'sublimity)

; (require 'sublimity)
; (require 'sublimity-scroll)
; (require 'sublimity-map) ;; experimental
; (require 'sublimity-attractive)

; (sublimity-mode 1)

;; Absolutely EVAPORATE ALL Emacs bindings!

(package-install 'ergoemacs-mode )

(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

;; All-the-icons!

(package-install 'all-the-icons)

; Install those dang 'ol fonts
(let ((cool-file "fonts-installed-vlisp.vmacs"))
  (if (not (file-exists-p cool-file))
      (progn
        (write-region "" "" cool-file)
        (all-the-icons-install-fonts t))
      (print "Fonts already installed, nice. 8)" #'external-debugging-output)))

(use-package all-the-icons
  :if (display-graphic-p))
; (use-package all-the-icons
;   :if (display-graphic-p))

;; Centaur-tabs

(package-install 'centaur-tabs)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<iso-lefttab>" . centaur-tabs-backward)
  ("C-<tab>" . centaur-tabs-forward))

;; Make tab scrolling behave like VSCode/Pulsar.
;; (setq centaur-tabs-cycle-scope 'tabs)
(setq centaur-tabs-style "alternate")
;; Bigger height for 1920x1080
(setq centaur-tabs-height 32)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-close-button " x ")

;; Little * when modified but not saved.
(setq centaur-tabs-set-modified-marker t)
(setq centaur-tabs-modified-marker "*")

;; Now make it automatically alphabetically order! :D
(centaur-tabs-enable-buffer-alphabetical-reordering)
(setq centaur-tabs-adjust-buffer-order t)



;; Stop someone from accidentally closing the dashboard.
(defun centaur-tabs-hide-tab (x)
  "Do no to show buffer X in tabs."
  (let ((name (format "%s" x)))
    (or
     ;; Current window is not dedicated window.
     (window-dedicated-p (selected-window))

     ;; Buffer name not match below blacklist.
     (string-prefix-p "*epc" name)
     (string-prefix-p "*helm" name)
     (string-prefix-p "*Helm" name)
     (string-prefix-p "*Compile-Log*" name)
     (string-prefix-p "*lsp" name)
     (string-prefix-p "*company" name)
     (string-prefix-p "*Flycheck" name)
     (string-prefix-p "*tramp" name)
     (string-prefix-p " *Mini" name)
     (string-prefix-p "*help" name)
     (string-prefix-p "*straight" name)
     (string-prefix-p " *temp" name)
     (string-prefix-p "*Help" name)
     (string-prefix-p "*mybuf" name)
     (string-prefix-p "*dashboard*" name)

     ;; Is not magit buffer.
     (and (string-prefix-p "magit" name)
          (not (file-name-extension name)))
     )))

;; Treemacs

(package-install 'treemacs)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(add-hook 'emacs-startup-hook 'treemacs)

;; Atom style dashboard.

(package-install 'dashboard)

(require 'dashboard)

;; Or if you use use-package
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; Center the dashboard.
(setq dashboard-center-content t)

;; Set dashboard title.
(setq dashboard-banner-logo-title "Welcome to Vmacs!")

;; Set the banner.
(setq dashboard-startup-banner "~/.emacs.d/vmacs/vmacs-logo.txt")

;; Use all-the-icons.
(setq dashboard-icon-type 'all-the-icons)
(setq dashboard-set-file-icons t)

;; Useful things in dashboard
(setq dashboard-footer-messages '("<- Rightclick the sidebar to get started!"))

;; Common Lisp POWER PACK WOO!

;; SLY
(package-install 'sly)

;; ParEdit
(package-install 'paredit)

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)


;; Enable parenthesis visualization. Modes stack.
(defvar vmacs-fancy-parentheses-highlight-mode 1)

;; Mode 1 Shadow mode. RED, trails out to darker shades of red further out of scope.
(if (>= vmacs-fancy-parentheses-highlight-mode 1)
  (progn 
    (print "Parentheses shadow mode enabled." #'external-debugging-output)
    (package-install 'highlight-parentheses)
    (require 'highlight-parentheses)
    (define-globalized-minor-mode global-highlight-parentheses-mode highlight-parentheses-mode
      (lambda nil (highlight-parentheses-mode t)))
    (global-highlight-parentheses-mode t)))
        
;; Mode 2, RAINBOWS WOOOO. https://youtu.be/6CR5x3BAelk?t=3
(if (>= vmacs-fancy-parentheses-highlight-mode 2)
  (progn
    (print "Parentheses rainbow mode enabled" #'external-debugging-output)
    (package-install 'rainbow-delimiters)
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)))

;; All other cases. Mode 0, disabled.
(if (<= vmacs-fancy-parentheses-highlight-mode 0) (print "Parentheses mode disabled." #'external-debugging-output))

; (show-paren-mode 1)
; (setq show-paren-when-point-inside-paren 1)
; (setq show-paren-delay 0)

;;! Very important section!
;;! This section is specifically designated for quality of life improvements!

;;* Begin portion A. Credit: https://unix.stackexchange.com/questions/19874/prevent-unwanted-buffers-from-opening

;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

;;* End portion A.

;; Single click folder expansion in treemacs.
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;; Stop the delete key from being weird.
(normal-erase-is-backspace-mode 1)

;;! This section is for additional keybindings!
;; So this can be real nice. :)

;; Show/hide Treemacs.
(define-key ergoemacs-user-keymap (kbd "<f5>") 'treemacs)

;; Toggle comment out. https://stackoverflow.com/a/9697222
;; FIXME: This needs to only take line numbers into consideration
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (print (format "%s, end" beg end) #'external-debugging-output)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
(define-key ergoemacs-user-keymap (kbd "C-/") 'comment-or-uncomment-region-or-line)



;;! END IMPORTANT SECTION!

;; This just kinda showed up here so I'm not gonna touch it incase I end up using sublimity.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(package-selected-packages '(sublimity)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
