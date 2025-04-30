package.path = os.getenv("HOME") .. "/.emacs.d/emacs/?.lua;" .. package.path

local em = require("emacs")
local ui = require("ui")
local pakage = require("package")

print(em.emacs_init_time())

local function blah()
    functioncall(emacs_environment, "interactive", 0, {})
end

function testFunction()
    print("testing!")
    return false
end

expose_function(
    emacs_environment,
    "testing",
    "Reset GC threshold to a more sane value",
    1,
    true,
    testFunction
)

--! note: if you functioncall into your own function it's gonna blow up
-- functioncall(emacs_environment, "testing", 1, {"hi"})



em.eval("(+ 1 2)")

em.eval_expression('(print "hello world" #\'external-debugging-output)')



-- em.set("unread-command-events", "C-g")
