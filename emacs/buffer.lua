--- Buffer related functions.

local em = require("emacs")

local buf = {}

--- Get the current buffer.
function buf.current_buffer()
    return em.run("current-buffer")
end

--- This function returns a buffer named buffer-or-name. The buffer returned does not become the current buffer—this function does not change which buffer is current.
--- buffer-or-name must be either a string or an existing buffer. If it is a string and a live buffer with that name already exists, get-buffer-create returns that buffer. If no such buffer exists, it creates a new buffer. If buffer-or-name is a buffer instead of a string, it is returned as given, even if it is dead.
function buf.get_buffer_create(buffer_or_name, optional_inhibit_buffer_hooks)
    return em.run("get-buffer-create", buffer_or_name, optional_inhibit_buffer_hooks)
end
return buf
