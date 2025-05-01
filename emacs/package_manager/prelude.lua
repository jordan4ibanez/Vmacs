--- Prelude package manager.
--- Built on top of the standard emacs package system.
--- It allows you to import packages if you don't feel like
--- rewriting them in lua.
--- It's called prelude because it sounds cool and it's literally
--- the introduction into the entire IDE.

local em = require("emacs")
local str = require("str")
local buf = require("buffer")

em.require(em.intern("package"))

local prelude = {}

function prelude.init()
    em.run("package-initialize")
end

function prelude.enable_native_compilation()
    em.set(em.intern("package-native-compile"), true)
end

function prelude.add_pkg_archive(archive)
    em.add_to_list(em.intern("package-archives"), em.cons(archive["name"], archive["url"]))
end

function prelude.refresh_contents()
    em.run("package-refresh-contents")
end

--- Check if a package is installed or not
-- @param pkg Symbol representing a package
-- @return True if the package is installed, false otherwise
function prelude.is_installed(pkg)
    return em.run("package-installed-p", pkg) ~= nil
end

function prelude.install(pkg)
    em.run("package-install", pkg)
end

function prelude.install_if_not_installed(pkg)
    if not pakage.is_installed(pkg) then
        pakage.install(pkg)
    end
end

--- Converts lua boolean into emacs boolean. Or whatever it was.
local function booleanize(input)
    if (type(input) == "boolean") then
        if (input) then
            return "t"
        else
            return "nil"
        end
    end
    -- Else, good luck!
    return input
end

--- Super function.
---
--- This is an integration of the standard elisp use-package lambda into lua 5.2.
---
--- You might want to read the code to see how to use this.
function prelude.use_package(package_name, def)
    -- If you're having trouble understanding any of this:
    -- https://github.com/jwiegley/use-package

    -- It all starts with a little string.
    local s = ""
    local indent = ""
    -- Then a little function.
    local function a(input)
        s = s .. indent .. input .. "\n"
        -- This is just so I can read this.
        if (indent == "") then
            indent = "    "
        end
    end
    -- And it's off down the hill.
    a("(use-package " .. package_name)
    a(":ensure " .. tostring(booleanize(def.ensure)))

    --- In the hook table, hooks must be defined as:
    --- ["function-name"] = {"hook-1", "hook-2"}
    if (def.hook) then
        --//todo: make this add a :hook for each thing
        a(":hook")
    end

    -- And then it closes just like that.
    a(")")

    print(s)
end

return prelude;
