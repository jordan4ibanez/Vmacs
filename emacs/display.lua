--- Display related functions.

local em = require("emacs")

local disp = {}

--- This function returns t if popup menus are supported on display, nil if not. Support for popup menus requires that the mouse be available, since the menu is popped up by clicking the mouse on some portion of the Emacs display.
function disp.display_popup_menus_p(optional_display)
    return em.run("display-popup-menus-p", optional_display)
end

--- This function returns t if display is a graphic display capable of displaying several frames and several different fonts at once. This is true for displays that use a window system such as X, and false for text terminals.
function disp.display_graphic_p(optional_display)
    return em.run("display-graphic-p", optional_display)
end

--- This function returns t if display has a mouse available, nil if not.
function disp.display_mouse_p(optional_display)
    return em.run("display-mouse-p", optional_display)
end

--- This function returns t if the screen is a color screen.
function disp.display_color_p(optional_display)
    return em.run("display-color-p", optional_display)
end

--- This function returns t if the screen can display shades of gray. (All color displays can do this.)
function disp.display_grayscale_p(optional_display)
    return em.run("display-grayscale-p", optional_display)
end

--- This function returns non-nil if all the face attributes in attributes are supported (see Face Attributes).
function disp.display_supports_face_attributes_p(attributes, optional_display)
    return em.run("display-supports-face-attributes-p", attributes, optional_display)
end

--- This function returns t if display supports selections. Windowed displays normally support selections, but they may also be supported in some other cases.
function disp.display_selections_p(optional_display)
    return em.run("display-selections-p", optional_display)
end

--- This function returns t if display can display images. Windowed displays ought in principle to handle images, but some systems lack the support for that. On a display that does not support images, Emacs cannot display a tool bar.
function disp.display_images_p(optional_display)
    return em.run("display-images-p", optional_display)
end

--- This function returns the number of screens associated with the display.
function disp.display_screens(optional_display)
    return em.run("display-screens", optional_display)
end

--- This function returns the height of the screen in pixels.
function disp.display_pixel_height(optional_display)
    return em.run("display-pixel-height", optional_display)
end

--- This function returns the width of the screen in pixels.
function disp.display_pixel_width(optional_display)
    return em.run("display-pixel-width", optional_display)
end

--- This function returns the height of the screen in millimeters, or nil if Emacs cannot get that information.
function disp.display_mm_height(optional_display)
    return em.run("display-mm-height", optional_display)
end

--- This function returns the width of the screen in millimeters, or nil if Emacs cannot get that information.
function disp.display_mm_width(optional_display)
    return em.run("display-mm-width", optional_display)
end

--- This function returns the backing store capability of the display. Backing store means recording the pixels of windows (and parts of windows) that are not exposed, so that when exposed they can be displayed very quickly.
function disp.display_backing_store(optional_display)
    return em.run("display-backing-store", optional_display)
end

--- This function returns non-nil if the display supports the SaveUnder feature. That feature is used by pop-up windows to save the pixels they obscure, so that they can pop down quickly.
function disp.display_save_under(optional_display)
    return em.run("display-save-under", optional_display)
end

--- This function returns the number of planes the display supports. This is typically the number of bits per pixel. For a tty display, it is log to base two of the number of colors supported.
function disp.display_planes(optional_display)
    return em.run("display-planes", optional_display)
end

--- This function returns the visual class for the screen. The value is one of the symbols static-gray (a limited, unchangeable number of grays), gray-scale (a full range of grays), static-color (a limited, unchangeable number of colors), pseudo-color (a limited number of colors), true-color (a full range of colors), and direct-color (a full range of colors).
function disp.display_visual_class(optional_display)
    return em.run("display-visual-class", optional_display)
end

--- This function returns the number of color cells the screen supports.
function disp.display_color_cells(optional_display)
    return em.run("display-color-cells", optional_display)
end

--- This function returns the list of version numbers of the GUI window system running on display, such as the X server on GNU and Unix systems. The value is a list of three integers: the major and minor version numbers of the protocol, and the distributor-specific release number of the window system software itself. On GNU and Unix systems, these are normally the version of the X protocol and the distributor-specific release number of the X server software. On MS-Windows, this is the version of the Windows OS.
function disp.x_server_version(optional_display)
    return em.run("x-server-version", optional_display)
end

--- This function returns the vendor that provided the window system software (as a string). On GNU and Unix systems this really means whoever distributes the X server. On MS-Windows this is the vendor ID string of the Windows OS (Microsoft).
function disp.x_server_vendor(optional_display)
    return em.run("x-server-vendor", optional_display)
end

return disp
