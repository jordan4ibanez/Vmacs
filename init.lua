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

-- I don't feel like looking at the startup screen.
em.set_intern("inhibit-startup-screen", 1)


local function startup_hook()
    em.setopt_intern({
        ["gc-cons-threshold"] = 800000,
        ["gc-cons-percentage"] = 0.1
    })
end

em.add_hook_intern(em.Hook.emacs_startup_hook, startup_hook, "startup_hook")
