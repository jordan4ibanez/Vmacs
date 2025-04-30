--- General emacs functions

emacs = {}

emacs.Mode = { ENABLE = 1, DISABLE = -1 }

--- Set a symbol to a value
-- @param name Symbol to set the value for
-- @param value Value to set
-- @return value
function emacs.set(name, value)
   return functioncall(emacs_environment, "set", 2, {name, value})
end

--- Set a symbols default value
-- @param name Symbol to set the value for
-- @param value Value to set
-- @return value
function emacs.set_default(name, value)
   return functioncall(emacs_environment, "set-default", 2, {name, value})
end

--- Display a message inside emacs
-- @param msg The message to be displayed
function emacs.message(msg)
   functioncall_no_return(emacs_environment, "message", 1, {msg})
end

--- Get the time emacs took to initialize
-- @return String displayig timestamp, i.e. "1.12 seconds"
function emacs.emacs_init_time()
   return functioncall(emacs_environment, "emacs-init-time", 0, {})
end

--- Create a symbol
-- @param sym_name Name of the symbol
-- @return A userdata object. ONLY USE THE RETURNED VALUE IN OTHER EMACS FUNCTIONS
function emacs.intern(sym_name)
   return functioncall(emacs_environment, "intern", 1, {sym_name})
end

--- Create a cons cell
-- @param car The car of the cons
-- @param cdr The cdr of the cons
-- @return A table representing a cons cell
function emacs.cons(car, cdr)
   cell = {}
   cell["type"] = "cons"
   cell["car"] = car
   cell["cdr"] = cdr
   return cell
end

--- Append a value to a list
-- @param name Interned symbol of the list to append to
-- @param value The value to append
function emacs.add_to_list(list, value)
   functioncall(emacs_environment, "add-to-list", 2, {list, value})
end

--- Add a value to a list without triggering return value conversion
-- Use this when appending to large lists like `auto-mode-alist` to prevent segfaults
-- @param name Interned symbol of the list to append to
-- @param value The value to append
function emacs.add_to_list_no_ret(list, value)
   functioncall_no_return(emacs_environment, "add-to-list", 2, {list, value})
end

--- Load a feature
-- @param feature The feature to load
function emacs.require(feature)
   functioncall_no_return(emacs_environment, "require", 1, {feature})
end

--- Execute a file of lisp code
-- @param file Name of file to load
-- @return Returns true if the file exists and loads successfully
function emacs.load(file)
   return functioncall(emacs_environment, "load", 1, {file})
end

--- Evaluate elisp code
-- @param form Elisp code to evaluate
-- @return The return value of the evaluated code
function emacs.eval(form)
   return functioncall(emacs_environment, "eval", 1, {form})
end

function emacs.add_hook(hook, func, lm_local)
   if not lm_local then
      functioncall_no_return(emacs_environment, "add-hook", 2, {hook, func})
   else
      functioncall_no_return(emacs_environment, "add-hook", 4, {hook, func, nil, true})
   end
end

function emacs.make_local_variable(symbol)
   return functioncall(emacs_environment, "make-local-variable", 1, {symbol})
end

function emacs.kbd(keys)
   return functioncall(emacs_environment, "kbd", 1, {keys})
end

function emacs.define_key(keymap, key, def)
   functioncall_no_return(emacs_environment, "define-key", 3, {keymap, key, def})
end

return emacs
