module emacs;

import emacs_module;

pragma(msg, "hello from compiler");

/// Emacs has this thing where it needs to have this defined or it explodes.
export extern (C) __gshared int plugin_is_GPL_compatible;
