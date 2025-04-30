;; Can't start the bootstrap without module support.
(if (not (eq module-file-suffix nil))
    (print "Has module support. Firing up!" #'external-debugging-output)
    (error "No module support. Recompile with module support."))


(module-load "./liblua_mode.so")
