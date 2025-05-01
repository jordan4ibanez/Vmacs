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

--- This function makes window display buffer-or-name. window should be a live window; if nil, it defaults to the selected window. buffer-or-name should be a buffer, or the name of an existing buffer. This function does not change which window is selected, nor does it directly change which buffer is current (see The Current Buffer). Its return value is nil.
function buf.set_window_buffer(window, buffer_or_name, optional_keep_margins)
    return em.run("set-window-buffer", window, buffer_or_name, optional_keep_margins)
end

return buf
