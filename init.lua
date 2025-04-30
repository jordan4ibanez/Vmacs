package.path = os.getenv("HOME") .. "/.emacs.d/emacs/?.lua;" .. package.path

local em = require("emacs")
local ui = require("ui")
local pakage = require("package")

print("startup time: " .. em.emacs_init_time())


emacs.set(em.intern("inhibit-startup-screen"), 1)

-- emacs.run("kill-buffer", emacs.run("get-buffer-create", "*Messages*"))

local test_buffer = emacs.run("get-buffer-create", "*test*")


emacs.run("switch-to-buffer", test_buffer)
emacs.run("insert-into-buffer", test_buffer)

local marker_point = em.intern("marker-point")

emacs.run("push-mark")
local start = emacs.run("region-beginning")
-- local ending = emacs.run("region-ending")
emacs.run("goto-char", start)
emacs.run("insert", "Hello from lua in D running in elisp! :D")



--! That's cool.
-- emacs.run("switch-to-buffer", emacs.run("get-buffer-create", "*scratch*"))


print("startup time: " .. em.emacs_init_time())
