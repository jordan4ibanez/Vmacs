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


-- print("startup time: " .. em.emacs_init_time())

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

local function deploy()
    print("deploy!")
end

em.expose_function(deploy, "test-deployment")

prelude.use_package("package", {
    ensure = false,
    custom = {
        
        ["package-vc-register-as-project"] = false,
        -- Auto-download package if not exists.
        ["use-package-always-ensure"] = true,
        -- Let imenu finds use-package definitions
        ["use-package-enable-imenu-support"] = true
    }
})


-- prelude.use_package("emacs", {
--     ensure = false,

--     hook = {
--         -- Function name, lists hooks.
--         ["visual-wrap-prefix-mode"] = {
--             "prog-mode",
--             "text-mode",
--             "conf-mode",
--             "help-mode"
--         },
--         ["display-line-numbers-mode"] = {
--             "prog-mode",
--             "text-mode",
--             "conf-mode"
--         }
--     },

--     custom = {


--     }
-- })

-- --! PHASE 1 CREATION OF HOOK FUNCTION
-- local function deploy()
--     print("deploy!")
-- end

-- em.expose_function(deploy, "test-deployment")

-- --! PHASE 2 DEPLOYMENT AND HOOKING FUNCTION INTO USE-PACKAGE

-- em.run_string(
--     [[


-- (use-package emacs
--   :ensure nil
--   :hook (prog-mode . test-deployment))
--     ]])
