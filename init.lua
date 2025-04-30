package.path = os.getenv("HOME") .. "/.emacs.d/emacs/?.lua;" .. package.path

local em = require("emacs")
local ui = require("ui")
local pakage = require("package")

print("startup time: " .. em.emacs_init_time())



local function testFunction()
    print("elisp calling lua in D!")
end

expose_function(
    emacs_environment,
    "testing",
    "Reset GC threshold to a more sane value",
    0,
    false,
    testFunction
)

--! note: if you functioncall into your own function it's gonna blow up.
-- functioncall(emacs_environment, "testing", 1, {"hi"})


local function whatTheHeck()
    em.eval('(print "hello world" #\'external-debugging-output)')
end

expose_function(
    emacs_environment,
    "wtf",
    "",
    0,
    false,
    whatTheHeck
)

-- function blah()
--     -- functioncall(emacs_environment, "lisp-interaction-mode", 0, {})




-- end

-- blah()

-- emacs.run_no_return("generate-new-buffer", "test*")

ui.blink_cursor_mode(emacs.Mode.DISABLE)

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


-- em.run("make-frame", "test")

-- emacs.run_no_return("set-window-buffer", "test*")

-- functioncall(emacs_environment, "generate-new-buffer", 1, { "hi" })

-- functioncall(emacs_environment, "generate-new-buffer", 1, { "hi" })


-- em.set("unread-command-events", "C-g")
