--- General command related functions
---
local em = require("emacs")

local com = {}

--- Open the tutorial.
function com.help_with_tutorial()
    em.run("help-with-tutorial")
end

return com
