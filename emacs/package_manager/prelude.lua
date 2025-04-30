--- Prelude package manager.
--- Built on top of the standard emacs package system.
--- It allows you to import packages if you don't feel like
--- rewriting them in lua.

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
    functioncall(emacs_environment, "package-refresh-contents", 0, {})
end

--- Check if a package is installed or not
-- @param pkg Symbol representing a package
-- @return True if the package is installed, false otherwise
function prelude.is_installed(pkg)
    if (not em.run("package-installed-p", pkg)) then
        return false
    else
        return true
    end
end

function prelude.install(pkg)
    functioncall(emacs_environment, "package-install", 1, { pkg })
end

function prelude.install_if_not_installed(pkg)
    if not pakage.is_installed(pkg) then
        pakage.install(pkg)
    end
end

return prelude;
