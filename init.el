;; Enable MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;; Testing sublimity

;; (package-install 'sublimity)

;; (require 'sublimity)
;; (require 'sublimity-scroll)
;; (require 'sublimity-map) ;; experimental
;; (require 'sublimity-attractive)

(sublimity-mode 1)

;; Testing Centaur-tabs

(package-install 'centaur-tabs)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<iso-lefttab>" . centaur-tabs-backward)
  ("C-<tab>" . centaur-tabs-forward))



(setq inhibit-startup-message t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Ensure these are enabled.
(menu-bar-mode 1)
(tool-bar-mode 1)
(scroll-bar-mode 1)

;; Display line numbers in every buffer.
(line-number-mode 1)
(global-display-line-numbers-mode 1)



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
