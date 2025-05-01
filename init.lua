package.path = os.getenv("HOME") .. "/.emacs.d/emacs/?.lua;" .. package.path
package.path = ";" .. os.getenv("HOME") .. "/.emacs.d/emacs/package_manager/?.lua;" .. package.path

local em = require("emacs")
local ui = require("ui")
local pakage = require("package")
local com = require("commands")
local buf = require("buffer")
local num = require("numbers")
local disp = require("display")
local prelude = require("prelude")

print("startup time: " .. em.emacs_init_time())

-- I don't feel like looking at the startup screen.
em.set_intern("inhibit-startup-screen", 1)

-- Make the GC not explode.
local function startup_hook()
    em.setopt_intern({
        ["gc-cons-threshold"] = 800000,
        ["gc-cons-percentage"] = 0.1
    })
end
em.add_hook_intern(em.Hook.emacs_startup_hook, startup_hook, "startup_hook")

-- Disable theme on Terminal and enable Mouse Support.
if (not disp.display_graphic_p()) then
    print("running in terminal")
    em.run("xterm-mouse-mode", 1)
    if (em.eq(em.get("system-type"), em.get("window-nt"))) then
        ui.disable_theme(em.car(em.get("custom-enabled-themes")))
    end
end

-- em.message("hi")
em.run_string(
    [[
(use-package emacs
  :ensure nil
  :hook

  ((prog-mode text-mode conf-mode help-mode)
   . visual-wrap-prefix-mode)
  ((prog-mode text-mode conf-mode) . display-line-numbers-mode)
  :custom
  (undo-limit 80000000) ;; ⚠️👀
  (safe-local-variable-values
   '((eval remove-hook 'flymake-diagnostic-functions
           'elisp-flymake-checkdoc t)))

  (x-gtk-show-hidden-files t)
  (mouse-drag-and-drop-region t)
  (mouse-drag-and-drop-region-cross-program t)

  (show-paren-predicate
   '(not
     (or (derived-mode . special-mode) (major-mode . text-mode)
         (derived-mode . hexl-mode))))
  (show-paren-style 'parenthesis)
  (show-paren-when-point-inside-paren t)

  (delete-selection-mode t)
  (cursor-type 'bar)
  (context-menu-mode t)

  (truncate-lines t)
  ;; Exit message
  (confirm-kill-emacs nil)
  ;; No Undo Redos
  (undo-no-redo t)

  ;;; IMAGE
  (image-animate-loop t)

  ;; Only text-mode on new buffers
  (initial-major-mode 'text-mode)

  ;; Delete just 1 char (including tabs)
  (backward-delete-char-untabify-method nil)

  ;; Disable Welcome Screen
  (inhibit-startup-screen t)

  ;; Hide cursor in not focus windows
  (cursor-in-non-selected-windows nil)

  ;; Better Scrolling
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-interpolate-page t)
  (scroll-conservatively 101) ;; must be greater than or equal to 101
  (scroll-step 1)

  :config
  ;; WSL2 clipboard fix
  (if (file-executable-p "/path/to/win32yank.exe")
      (setopt interprogram-cut-function
              (lambda (text)
                (with-temp-buffer
                  (insert text)
                  (call-process-region (point-min) (point-max) "win32yank.exe" nil 0 nil "-i" "--crlf")))))

  ;; Alias
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; y-or-n-p with return
  (advice-add 'y-or-n-p :around
              (lambda (orig-func &rest args)
                (let ((query-replace-map (copy-keymap query-replace-map)))
                  (keymap-set query-replace-map "<return>" 'act)
                  (apply orig-func args))))

  ;; Configurations for Windows
  (if (eq system-type 'windows-nt)
      (setopt w32-get-true-file-attributes nil   ; decrease file IO workload
              w32-use-native-image-API t         ; use native w32 API
              w32-pipe-read-delay 0              ; faster IPC
              w32-pipe-buffer-size (* 64 1024))) ; read more at a time (was 4K)

  ;; Set Coding System
  (if (fboundp 'set-charset-priority)
      (set-charset-priority 'unicode))
  (prefer-coding-system 'utf-8)
  (setopt locale-coding-system 'utf-8)
  (unless (eq system-type 'windows-nt)
    (set-selection-coding-system 'utf-8))

  ;; Enable line numbers and pairs if buffer/file is writable
  (advice-add #'fundamental-mode :after (lambda (&rest _)
                                          (unless buffer-read-only
                                            (display-line-numbers-mode)
                                            (electric-pair-mode))))
  ;; Kill Scratch Buffer
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*"))

  ;; Fix Cases region commands
  ;; Use at your own risk.
  (put 'upcase-region     'disabled nil)
  (put 'downcase-region   'disabled nil)
  (put 'capitalize-region 'disabled nil)

  ;; Continue Comments.
  (setopt comment-multi-line t)
  (advice-add 'newline-and-indent :before-until
              (lambda (&rest _)
                (interactive "*")
                (when-let (((nth 4 (syntax-ppss (point))))
                           ((functionp comment-line-break-function))
                           (fill-prefix " *"))
                  (funcall comment-line-break-function nil)
                  t))))


    ]])
