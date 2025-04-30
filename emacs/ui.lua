--- UI related functions

local em = require("emacs")

local ui = {}

--- Set the menu bar mode
function ui.menu_bar_mode(mode)
    em.run("menu-bar-mode", mode)
end

--- Set the scroll bar mode
function ui.scroll_bar_mode(mode)
    em.run("scroll-bar-mode", mode)
end

--- Set the tool bar mode
function ui.tool_bar_mode(mode)
    em.run("tool-bar-mode", mode)
end

--- Set the blink cursor mode
function ui.blink_cursor_mode(mode)
    em.run("blink-cursor-mode", mode)
end

--- Search for a theme feature and load it
-- @param theme A symbol representing the theme to load
function ui.require_theme(theme)
    em.run("require-theme", theme)
end

--- Load and enable a theme
-- @param theme Theme to be loaded
function ui.load_theme(theme)
    em.run("load-theme", theme)
end

return ui
