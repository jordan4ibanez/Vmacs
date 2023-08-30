;; Enable MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq inhibit-startup-message t)
(print "hi")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Ensure these are enabled.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line numbers in every buffer.
(line-number-mode 1)
(global-display-line-numbers-mode 1)
