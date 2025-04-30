package.path = os.getenv("HOME") .. "/.emacs.d/emacs/?.lua;" .. package.path
package.path = ";" .. os.getenv("HOME") .. "/.emacs.d/emacs/package_manager/?.lua;" .. package.path

local em = require("emacs")
local ui = require("ui")
local pakage = require("package")
local com = require("commands")
local buf = require("buffer")
local num = require("numbers")
local prelude = require("prelude")

print("startup time: " .. em.emacs_init_time())

em.set_intern("inhibit-startup-screen", 1)

local function startup_hook()
    print("I am a startup hook!")
end

em.add_hook_intern("emacs-startup-hook", startup_hook, "startup_hook")

