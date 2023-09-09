;;note: This is for debugging purposes, causes a warning to stop the world.
;; (setq debug-on-error t)

;; The default is 800 kilobytes.  Measured in bytes.
;; 50 Megabytes.
;;WARNING: use only if gcmh is disabled.
;; (setq gc-cons-threshold (* 50 1000 1000))

;; A friendly terminal welcome. :)
(print "Welcome to Vmacs!" #'external-debugging-output)

;; I hope the user followed the directions or this ain't gonna work. :T
(add-to-list 'load-path "~/.emacs.d/vmacs/")

;; This will automatically fix use-package not being installed!
(let ((cool-file ".vmacs-fully-initialized"))
  (unless (file-exists-p cool-file)
    (progn
      (write-region "" "" cool-file)
      (package-initialize)
      (package-refresh-contents)
      (package-install 'use-package)
      (print "Vmacs first time run initialized!" #'external-debugging-output))))

;;pd Enable MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Turning this off can speed up startup time quite a bit!
;; Enable repository update.
(setq turn-on-automatic-package-updates nil)

(if turn-on-automatic-package-updates 
    (progn
      (unless package-archive-contents
        (package-refresh-contents))))

;;note: Before we even touch a single thing, make this thing start faster!

;;pd Garbage Collector Magic Hack
;;note: Otherwise known as gcmh
;;note: source https://github.com/daviwil/emacs-from-scratch/blob/master/show-notes/Emacs-Scratch-12.org
;;note: Improves responsiveness of Vmacs
;;WARNING: This is experimental, can consume a bit of power with the responsiveness. It's in testing.
;;yell This is currently being tested, recommended to disable it if you run into performance problems.
(defvar vmacs-garbage-collector-magic-hack-enabled t)

(if vmacs-garbage-collector-magic-hack-enabled
    (progn 
      (use-package gcmh :ensure t)
      (gcmh-mode 1)

      ;;note: Tune the GC to be between UBER aggressive & relaxed.
      (setq gcmh-idle-delay 1)

      ;;note: this is for debugging purposes
      (setq garbage-collection-messages nil)))


;; Enable hot reload!
;; This makes it easier to write out if clauses.
(unless (boundp 'vmacs-hot-reload)
    (setq vmacs-hot-reload nil))

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

;; Save place in line between sessions
(save-place-mode 1)

(auto-save-visited-mode 1)
(setq auto-save-visited-interval 30)

;; Stop the mouse scroll wheel from going crazy.
(setq mouse-wheel-progressive-speed nil)
;; Use default VSCode/Pulsar scrolling
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil)))

;; Make the cursor actually usable. [] -> |
(setq-default cursor-type 'bar)

;; ONLY spaces please!
(setq-default indent-tabs-mode nil)

;; Make pasting/selection overwrite work like normal.
;; FIXME: Think needs: https://www.gnu.org/software/emacs/manual/html_node/emacs/CUA-Bindings.html
(delete-selection-mode 1)

;; Disable word wrap
(set-default 'truncate-lines t)

;; Set the window title. https://emacs.stackexchange.com/a/46016
;; So all this is doing is building a string based on expressions!
(setq frame-title-format
    `((buffer-file-name "%b - ")
      "Vmacs"))

;; We gotta start with the theme maaaan. Doom-one is the absolute nicest out there.
;;pd Doom themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Stop Vmacs from scaring the poop out of someone.
;; Disable all bell features. (flashing, beeping)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;;pd DOOM Modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; Absolutely EVAPORATE ALL Emacs bindings!
;;pd ergoemacs
(use-package ergoemacs-mode :ensure t)

(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

;;note: Some things support one, some things support the other.
;;note: mix n' match
;;pd nerd-icons
(use-package nerd-icons :ensure t)
;;pd all-the-icons
(use-package all-the-icons :ensure t)

;; Install those dang 'ol fonts
;;note: this is a dot file, hidden by default in most file managers
(let ((cool-file ".vmacs-fonts-installed"))
  (unless (file-exists-p cool-file)
    (write-region "" "" cool-file)
    (nerd-icons-install-fonts t)
    (all-the-icons-install-fonts t)    
    (print "Fonts already installed, nice. 8)" #'external-debugging-output)))

;;pd Centaur-tabs
;;note: tabs like vscode
(use-package centaur-tabs :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<iso-lefttab>" . centaur-tabs-backward)
  ("C-<tab>" . centaur-tabs-forward))


; Make tab scrolling behave like VSCode/Pulsar.
; (setq centaur-tabs-cycle-scope 'tabs)
(setq centaur-tabs-style "alternate")
; Bigger height for 1920x1080
(setq centaur-tabs-height 32)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-close-button " x ")

; Little * when modified but not saved.
(setq centaur-tabs-set-modified-marker t)
(setq centaur-tabs-modified-marker " * ")

; Now make it automatically alphabetically order! :D
; (centaur-tabs-enable-buffer-alphabetical-reordering)
; (setq centaur-tabs-adjust-buffer-order t)

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

;; Organize centaur-tabs
(defun vmacs-match (input)
  (string-match-p (buffer-name) input))

(defun centaur-tabs-buffer-groups ()
  (interactive)
  (list
   (cond ((or (vmacs-match "*sly-inferior-lisp for sbcl*")
              (vmacs-match "*dashboard*")
              (vmacs-match "*sly-mrepl for sbcl*")
              (vmacs-match "*sly-events for sbcl")
              (vmacs-match "*ansi-term")
              (vmacs-match "*ansi-term<2>")
              (vmacs-match "*ansi-term<3>")
              (vmacs-match "*ansi-term<4>")
              (vmacs-match "*Async-native-compile-log*")
              (vmacs-match "*Warnings*"))
          "terminal-area")
         (t "vmacs"))))


;;pd Treemacs
;;note: vscode style sidebar
(unless vmacs-hot-reload
  (progn
    (use-package treemacs
      :ensure t
      :defer t
      :hook (after-init . treemacs)
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
   
    ;;wtf I have no idea why this depends on all-the-icons but I'm not gonna question it
    (use-package treemacs-nerd-icons :ensure t
      :config (treemacs-load-theme "nerd-icons"))))

;;pd dashboard
;;note: Atom style dashboard

;; Enabled by default.
(defvar enable-vmacs-dashboard t)

(if (eq enable-vmacs-dashboard t)
    (progn
     
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

      (setq dashboard-display-icons-p t) ;; display icons on both GUI and terminal
      (setq dashboard-icon-type 'nerd-icons) ;; use `nerd-icons' package

                                        ; (setq dashboard-set-heading-icons t)
      (setq dashboard-set-file-icons t)

      ;; Useful things in dashboard
      (setq dashboard-footer-messages '("Now with extra lisp!"))))


;;pd CTRLF
;;note: BETTER SEARCHING YEAH!
(use-package ctrlf :ensure t)
(ctrlf-mode +1)
(with-eval-after-load 'ctrlf
  ;;! CTRL+ENTER SEARCHES FORWARDS!
  (define-key ergoemacs-user-keymap (kbd "C-<return>") #'ctrlf-forward-default)
  ;;! CTRL+SHIFT+ENTER SEARCHES BACKWARDS!
  (define-key ergoemacs-user-keymap (kbd "C-S-<return>") #'ctrlf-backward-default))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode 1)
 '(package-selected-packages
   '(use-package markdown-mode hl-todo paredit kind-icon corfu sly diff-hl real-auto-save treemacs treemacs-tab-bar treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired rainbow-delimiters highlight-parentheses ergoemacs-mode doom-themes dashboard centaur-tabs)))

;;yell !!!! Common Lisp POWER PACK WOO!!!!

;;pd diff-hl
;;note: shows unmerged line changes
(use-package diff-hl :ensure t)

(diff-hl-flydiff-mode)
(global-diff-hl-mode)


;;pd SLY
;;note: Vmacs Common Lisp REPL
(use-package sly :ensure t)
(setq inferior-lisp-program "sbcl")

;;pd corfu
;;note: autocomplete
(use-package corfu :ensure t
  :init (global-corfu-mode))
(setq corfu-auto t)

;;! This is called this for a reason :)
(defvar i-have-a-fast-computer t)

(if i-have-a-fast-computer
    (setq corfu-auto        t
          corfu-auto-delay  0.25 ;; TOO SMALL - NOT RECOMMENDED
          corfu-auto-prefix 4
          completion-styles '(basic)))

;; Only hit enter to select
(define-key corfu-map [tab] nil)
(define-key corfu-map "\t" nil)

;;pd kind-icon
;;note: nice icons for corfu autocomplete
;;note: does not work with sly, don't know why
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;pd Vmacs parentheses helper choice
;;note: 0 is off. Only set it to this if you like your code to look crazy.
;;note: 1 is traditional paredit. VERY Strict.
;;note: 2 is newer smartparens. A little more loosey goosey.
;;note: defaults to 1.
(setq vmacs-parentheses-helper 1)

(if (= vmacs-parentheses-helper 1)
    ;;pd ParEdit
    ;;note: Enforce Common Lisp bracket styling
    (progn 
      (use-package paredit :ensure t)
      (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
      (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
      (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
      (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
      (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
      (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
      (add-hook 'scheme-mode-hook           #'enable-paredit-mode)))

;;pd smartparens
;;note: Enforce common lisp bracket styling with nice evolution from ParEdit
(if (= vmacs-parentheses-helper 2)
    (progn
      (use-package smartparens :ensure t)
      (smartparens-strict-mode t)
      (smartparens-global-mode t)))

;;pd show-paren-mode
;;note: This should always be enabled because it's extremely helpful.
;;note: https://www.emacswiki.org/emacs/ShowParenMode
(show-paren-mode 1)

;;pd Parenthesis Visualization helper.
;;note: Enable parenthesis visualization. Modes stack.
(defvar vmacs-fancy-parentheses-highlight-mode 1)

;; Mode 1 Shadow mode. RED, trails out to darker shades of red further out of scope.
(if (>= vmacs-fancy-parentheses-highlight-mode 1)
  (progn 
    (print "Parentheses shadow mode enabled." #'external-debugging-output)
    (use-package highlight-parentheses :ensure t)
    (require 'highlight-parentheses)
    (define-globalized-minor-mode global-highlight-parentheses-mode highlight-parentheses-mode
      (lambda nil (highlight-parentheses-mode t)))
    (global-highlight-parentheses-mode t)))
        
;; Mode 2, RAINBOWS WOOOO. https://youtu.be/6CR5x3BAelk?t=3
(if (>= vmacs-fancy-parentheses-highlight-mode 2)
  (progn
    (print "Parentheses rainbow mode enabled" #'external-debugging-output)
    (use-package rainbow-delimiters :ensure t)
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)))

;; All other cases. Mode 0, disabled.
(if (<= vmacs-fancy-parentheses-highlight-mode 0) (print "Parentheses mode disabled." #'external-debugging-output))

;;pd hl-todo
;;note: enables all these nice colorful comments
(use-package hl-todo :ensure t)

(setq hl-todo-keyword-faces
      '(("WARNING"    . "#FF0000")  ;; Pure RED
        ;; Stands for Very Important Section.
        ("VIS"        . "#FF0000")
        ("vis"        . "#FF0000")
        ;; Does what it says on the tin. :D
        ;; Don't yell too much, or you'll hurt your eyes!
        ("YELL"       . "#41FDFE")  ;; Bright Cyan
        ("yell"       . "#41FDFE")
        ;; I suppose you're gonna write angry comments someday. Here you go.
        ("ANGER"      . "#dd0055")  ;; Anger (yes that's the color name)
        ("anger"      . "#dd0055")
        ;; If you're making a todo list you can list them like shown below.
        ;; TL literally stands for "Todo List" and "Todo Todo". :P
        ("TODO"       . "#3c8d0d")  ;; Christmas Green.
        ("TL"         . "#3c8d0d")
        ("tl"         . "#3c8d0d")
        ("TT"         . "#3c8d0d")
        ("tt"         . "#3c8d0d")
        ("NOTE"       . "#4F7942")  ;; Fern Green
        ("note"       . "#4F7942")
        ("SUGGESTION" . "#4F7942")
        ("suggestion" . "#4F7942")
        ;; Sometimes, you just gotta say it. Like "why is this even here??" type comments.
        ;; Hot pink on a dark theme definitely makes me say wtf.
        ("WTF"        . "#FF69B4")  ;; Hot pink
        ("wtf"        . "#FF69B4")
        ;; Stands for Documentation Section
        ("DS"         . "#4F7942")
        ("ds"         . "#4F7942")
        ;; Stands for Package Documentation
        ("PD"         . "#fcb829")  ;; Mustard yellow
        ("pd"         . "#fcb829")
        ("FIXME"      . "#FF7518")  ;; Pumpkin orange
        ("PLEASE FIX" . "#FF7518")
        ("fixme"      . "#FF7518")
        ("please fix" . "#FF7518")
        ("DEBUG"      . "#A020F0")  ;; Pure PURPLE
        ("GOTCHA"     . "#FF4500")  ;; Orange red
        ("STUB"       . "#1E90FF")));; Dodger blue

;; Patch it to enable whole line https://github.com/tarsius/hl-todo/discussions/69#discussioncomment-4069108
(defun hl-todo--setup-regexp ()
  (concat "\\(\\<"
          "\\(" (mapconcat #'car hl-todo-keyword-faces "\\|") "\\)"
          "\\>"
	  "[^\"\n]*\\)"))

(defun hl-todo--setup ()
  (hl-todo--setup-regexp)
  (setq hl-todo--keywords
	`((,(lambda (bound) (hl-todo--search nil bound))
	   (0 (hl-todo--get-face) prepend t))))
  (font-lock-add-keywords nil hl-todo--keywords t))

(defvar hl-todo--syntax-table (copy-syntax-table text-mode-syntax-table))

(global-hl-todo-mode 1)

;;TODO sample todo list of fixing something
;;tl 1.) do the thing
;;tl 2.) do something else
;;TL 3.) The thing is now done

;;pd real-auto-save
;;note: Time based autosave :D
(use-package real-auto-save :ensure t)
(add-hook 'prog-mode-hook 'real-auto-save-mode)

;; 5 seconds by default.
(setq real-auto-save-interval 1)

;;pd markdown-mode
;;note: mode for README.md files
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))


;;yell BEGIN VERY IMPORTANT SECTION!
;;note: This section is specifically designated for quality of life improvements!

;; Make sly split vertically instead of horizontal
;; (setq split-height-threshold nil)
;; (setq split-width-threshold nil)
;; (setq shackle-rules '((sly-mode :align 'below)))

;;DS Begin portion A. Credit: https://unix.stackexchange.com/questions/19874/prevent-unwanted-buffers-from-opening

(setf vmacs-disable-debugging t)

(if vmacs-disable-debugging (progn 
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
                      (kill-buffer buffer)))))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

;;DS End portion A.

;; Automatically re-open last session.
;; ! This causes problems !!!
; (desktop-save-mode 1)
;; I dunno if there's are necessary but it's working so I don't want to touch it.
; (savehist-mode 1) 
; (setq bookmark-save-flag t)
;;* ^Continued from here.
;;* Instead, we'll just automatically maximize the window
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Single click folder expansion in treemacs.
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map (kbd "<mouse-1>") #'treemacs-single-click-expand-action))

;; Stop the delete key from being weird.
; (normal-erase-is-backspace-mode 1)

;;! This section is for additional keybindings!
;; So this can be real nice. :)



;; Show/hide Treemacs.
(define-key ergoemacs-user-keymap (kbd "<f5>") 'treemacs)

;; Toggle comment out.
;; Thank user1017523: https://stackoverflow.com/a/20064658
(defun vmacs-comment-line ()
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (comment-or-uncomment-region start end)))

(define-key ergoemacs-user-keymap (kbd "C-/") 'vmacs-comment-line)

;; Make the del key behave like normal.
(define-key ergoemacs-user-keymap (kbd "<delete>") 'delete-forward-char)

;; Make CTRL+backspace work like VSCode https://emacs.stackexchange.com/a/30404
(defun backward-kill-char-or-word ()
  (interactive)
  (cond 
   ((looking-back (rx (char word)) 1)
    (backward-kill-word 1))
   ((looking-back (rx (char blank)) 1)
    (delete-horizontal-space t))
   (t
    (backward-delete-char 1))))

(define-key ergoemacs-user-keymap (kbd "C-<backspace>") 'backward-kill-char-or-word)

;; Make shift-tab unindent line like vscode
;; FIXME: region changes so this just exits when a region is selected
;; NOTE: Works for single lines nicely though :)
(defun vmacs-unindent-line ()
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (indent-rigidly start end -2)))

(define-key ergoemacs-user-keymap (kbd "<backtab>") 'vmacs-unindent-line)

;; Disable escape from trying to exit files.
;; https://www.reddit.com/r/emacs/comments/10l40yi/how_do_i_make_esc_stop_closing_all_my_windows/ (danderzei)
(defun keyboard-escape-quit-alt ()
  "Alternative version of `keyboard-escape-quit` that does not change windows."
  (interactive)
  ;;note: fixes corfu acting like hot garbage
  (corfu-quit)
  (cond ((eq last-command 'mode-exited) nil)
        ((region-active-p)
         (deactivate-mark))
        ((> (minibuffer-depth) 0)
         (abort-recursive-edit))
        (current-prefix-arg
         nil)
        ((> (recursion-depth) 0)
         (exit-recursive-edit))
        (buffer-quit-function
         (funcall buffer-quit-function))
        ;;((not (one-window-p t))
        ;; (delete-other-windows))
        ((string-match "^ \\*" (buffer-name (current-buffer)))
         (bury-buffer))))
(define-key ergoemacs-user-keymap (kbd "<escape>") 'keyboard-escape-quit-alt)


;; Start up SLY:  F12
;;! Best for performance testing.
;; Compile a file:  CTRL+G
;;! Best for debugging/prototyping.
;; Eval a function: CTRL+D
;; Eval a file: CTRL+R
(defun start-sly-in-treemacs-root-dir ()
  (interactive)
  (progn
    (let ((default-directory (treemacs--current-builtin-project-function)))
      (print default-directory #'external-debugging-output)
      (sly))))

(with-eval-after-load 'sly
  (progn
    (define-key ergoemacs-user-keymap (kbd "<f12>") 'start-sly-in-treemacs-root-dir)
    (define-key ergoemacs-user-keymap (kbd "C-g") 'sly-compile-and-load-file)
    (define-key ergoemacs-user-keymap (kbd "C-d") 'sly-eval-defun)
    (define-key ergoemacs-user-keymap (kbd "C-r") 'sly-eval-buffer)))

;; Fix home key not going to beggining of line's text!
(define-key ergoemacs-user-keymap (kbd "<home>") 'back-to-indentation)

;; Fix CTRL+left & right
(define-key ergoemacs-user-keymap (kbd "C-<left>") 'backward-word)
(define-key ergoemacs-user-keymap (kbd "C-<right>") 'forward-word)


;; Vmacs ULTRA RELOAD
(defun vmacs-hot-reload ()
  "reload your init.el file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(define-key ergoemacs-user-keymap (kbd "<f9>") 'vmacs-hot-reload)

;; CTRL+` to open up a terminal https://emacs.stackexchange.com/a/48477
(defun vmacs-terminal ()
  "Start a terminal emulator in a new window."
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (ansi-term (executable-find "bash")))

(define-key ergoemacs-user-keymap (kbd "C-`") 'vmacs-terminal)

;; Stop Vmacs from pestering you with the warning about running processes
(setq confirm-kill-processes nil)


;;yell END VERY IMPORTANT SECTION!


;;note: vis Begin the drop down menu modifications!

;; Make the "File" menu less confusing to new users.
(define-key global-map [menu-bar file project-dired] nil)
(define-key global-map [menu-bar file dired] nil)

;; This replaces project dired with some actual useful utility.
(define-key global-map
	    [menu-bar file dired]
	    '("Open Folder" . treemacs-add-project-to-workspace))

(define-key global-map
	    [menu-bar file project-dired]
	    '("Close Folder" . treemacs-remove-project-from-workspace))

;;note: End the drop down menu modifications!

;; This gets created by Easy-Customization
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Easy-Customization.html

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setf vmacs-hot-reload t)

;; Make gc pauses faster by decreasing the threshold.
;; 2 Megabytes.
;;WARNING: use only if gcmh is disabled.
;; (setq gc-cons-threshold (* 2 1000 1000))
