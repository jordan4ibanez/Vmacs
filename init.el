(setq debug-on-error t)

;; Can't start the bootstrap without module support.
(if (not (eq module-file-suffix nil))
    (princ "[elisp]: Has module support. Firing up!\n" #'external-debugging-output)
    (error "[elisp]: No module support. Recompile with module support."))

(module-load "./libvmacs.so")

;; Close the D library when emacs exits.
;; The function is coming from the D library.
(add-hook 'kill-emacs-hook 
    (lambda () 
        (terminate-vmacs)))