package.path = './emacs/?.lua;' .. package.path
local em = require("emacs")

em.require(em.intern("package"))

pakage = {}

function package_initialize()
   functioncall(emacs_environment, "package-initialize", 0, {})
end

function pakage.init()
   package_initialize()
end

function pakage.enable_native_compilation()
   em.set(em.intern("package-native-compile"), true)
end

function pakage.add_pkg_archive(archive)
   em.add_to_list(em.intern("package-archives"), em.cons(archive["name"], archive["url"]))
end

function pakage.refresh_contents()
   functioncall(emacs_environment, "package-refresh-contents", 0, {})
end

--- Check if a package is installed or not
-- @param pkg Symbol representing a package
-- @return True if the package is installed, false otherwise
function pakage.is_installed(pkg)
   if (functioncall(emacs_environment, "package-installed-p", 1, {pkg}) == nil) then
      return false
   else
      return true
   end
end

function pakage.install(pkg)
   functioncall(emacs_environment, "package-install", 1, {pkg})
end

function pakage.install_if_not_installed(pkg)
   if not pakage.is_installed(pkg) then
      pakage.install(pkg)
   end
end

return pakage
