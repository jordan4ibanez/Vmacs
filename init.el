;; Can't start the bootstrap without module support.
(if (not (eq module-file-suffix nil))
    (print "Has module support. Firing up!" #'external-debugging-output)
    (error "No module support. Recompile with module support."))


(module-load "./liblua_mode.so")




;; Close the D library when emacs exits.
;; The function is coming from the D library.
(add-hook 'kill-emacs-hook 
    (lambda () 
        (terminate-vmacs)))