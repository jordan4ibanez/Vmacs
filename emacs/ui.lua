--- UI related functions

local em = require("emacs")

local ui = {}

--- Set the menu bar mode
function ui.menu_bar_mode(mode)
    em.run(emacs_environment, "menu-bar-mode", 1, { mode })
end

--- Set the scroll bar mode
function ui.scroll_bar_mode(mode)
    em.run(emacs_environment, "scroll-bar-mode", 1, { mode })
end

--- Set the tool bar mode
function ui.tool_bar_mode(mode)
    em.run(emacs_environment, "tool-bar-mode", 1, { mode })
end

--- Set the blink cursor mode
function ui.blink_cursor_mode(mode)
    em.run(emacs_environment, "blink-cursor-mode", 1, { mode })
end

--- Search for a theme feature and load it
-- @param theme A symbol representing the theme to load
function ui.require_theme(theme)
    em.run(emacs_environment, "require-theme", 1, { theme })
end

--- Load and enable a theme
-- @param theme Theme to be loaded
function ui.load_theme(theme)
    em.run(emacs_environment, "load-theme", 1, { theme })
end

return ui
