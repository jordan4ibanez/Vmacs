--- Buffer related functions.

local em = require("emacs")

local buf = {}

--- Get the current buffer.
function buf.current_buffer()
    return em.run("current-buffer")
end

return buf
