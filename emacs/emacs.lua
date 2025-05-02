--- General emacs functions.

local emacs = {}

emacs.Mode = { ENABLE = 1, DISABLE = -1 }
emacs.Hook = require("hook_defines")

--- Run emacs function with variables automatically distributed.
function emacs.run(functionName, ...)
    local values = { ... }
    return functioncall(emacs_environment, functionName, #values, values)
end

--- Run emacs function with variables automatically distributed with no return value.
function emacs.run_no_return(functionName, ...)
    local values = { ... }
    functioncall_no_return(emacs_environment, functionName, #values, values)
end

--- Set a symbol to a value
-- @param name Symbol to set the value for
-- @param value Value to set
-- @return value
function emacs.set(object, value)
    return emacs.run("set", object, value)
end

--- Set a symbol to a value automatically interning the string.
-- @param name Symbol to set the value for
-- @param value Value to set
-- @return value
function emacs.set_intern(name, value)
    return emacs.run("set", emacs.intern(name), value)
end

--- This is like setq (see above), but meant for user options. This macro uses the Customize machinery to set the variable(s) (see Defining Customization Variables). In particular, setopt will run the setter function associated with the variable.
function emacs.setopt(symbol, form)
    return emacs.run("setopt", symbol, form)
end

--- This is like setq (see above), but meant for user options. This macro uses the Customize machinery to set the variable(s) (see Defining Customization Variables). In particular, setopt will run the setter function associated with the variable.
--- Also this automatically interns a new symbol from a string.
--- If is passed a table, it will automatically iterate it.
function emacs.setopt_intern(name_or_table, form)
    if (type(name_or_table) == "table") then
        for k, v in pairs(name_or_table) do
            -- print(k, v)
            local x = emacs.intern_soft(k)
            if (x) then
                emacs.set(x, v)
            else
                emacs.set_intern(k, v)
            end
        end
    else
        emacs.set_intern(emacs.intern(name_or_table), form)
    end
end

--- Set a symbols default value
-- @param name Symbol to set the value for
-- @param value Value to set
-- @return value
function emacs.set_default(name, value)
    return emacs.run("set-default", name, value)
end

--- Display a message inside emacs
-- @param msg The message to be displayed
function emacs.message(msg)
    emacs.run_no_return("message", msg)
end

--- Get the time emacs took to initialize
-- @return String displayig timestamp, i.e. "1.12 seconds"
function emacs.emacs_init_time()
    return emacs.run("emacs-init-time")
end

--- Create a symbol
-- @param sym_name Name of the symbol
-- @return A userdata object. ONLY USE THE RETURNED VALUE IN OTHER EMACS FUNCTIONS
function emacs.intern(sym_name)
    return emacs.run("intern", sym_name)
end

--- Create a cons cell
-- @param car The car of the cons
-- @param cdr The cdr of the cons
-- @return A table representing a cons cell
function emacs.cons(car, cdr)
    local cell = {}
    cell["type"] = "cons"
    cell["car"] = car
    cell["cdr"] = cdr
    return cell
end

function emacs.car(list)
    emacs.run("car", list)
end

--- Add to a list symbol or a list name which will be interned into a symbol.
function emacs.add_to_list(list_or_name, element, optional_append)
    if (type(list_or_name) == "string") then
        list_or_name = emacs.intern(list_or_name)
    end
    return emacs.run("add-to-list", list_or_name, element, optional_append)
end

--- Add a value to a list without triggering return value conversion
-- Use this when appending to large lists like `auto-mode-alist` to prevent segfaults
-- @param name Interned symbol of the list to append to
-- @param value The value to append
function emacs.add_to_list_no_return(list_or_name, element, optional_append)
    if (type(list_or_name) == "string") then
        list_or_name = emacs.intern(list_or_name)
    end
    emacs.run_no_return("add-to-list", list_or_name, element, optional_append)
end

--- Load a feature
-- @param feature The feature to load
function emacs.require(feature)
    emacs.run_no_return("require", feature)
end

--- Load a feature interned.
-- @param feature The interned feature to load
function emacs.require_interned(feature)
    emacs.run_no_return("require", emacs.intern(feature))
end

--- Execute a file of lisp code
-- @param file Name of file to load
-- @return Returns true if the file exists and loads successfully
function emacs.load(file)
    return emacs.run("load", file)
end

--- Evaluate elisp code
-- @param form Elisp code to evaluate
-- @return The return value of the evaluated code
function emacs.eval(form)
    return emacs.run("eval", form)
end

--- Run arbitrary elisp code constructed from lua functions.
--- This can be useful for macro expansion automatically.
function emacs.run_string(input_string)
    -- This is less than ideal, but, at least it works.
    local old_buffer = emacs.run("current-buffer")
    local compiler_buffer = emacs.run("get-buffer-create", "compiler-buffer-for-lisp-lua-code")
    emacs.run("switch-to-buffer", compiler_buffer)
    emacs.run("insert", input_string);
    emacs.run("eval-buffer")
    if (emacs.run("kill-buffer", "compiler-buffer-for-lisp-lua-code") == nil) then
        print("warning: failed to kill the compiler-buffer-for-lisp-lua-code buffer!")
    end
end

--- Evaluate elisp code
-- @param form Elisp code to evaluate
-- @return The return value of the evaluated code
function emacs.eval_expression(form)
    return emacs.run("eval-expression", form)
end

function emacs.expose_function(func, function_name, arguments, does_return)
    arguments = arguments or 0
    does_return = does_return or false
    expose_function(emacs_environment, function_name, "...", arguments, does_return, func)
end

--- Your hook will get baked into the elisp machine and automatically executed at the proper time.
--- It is set up to pass in no variables at all. This is a simplicity choice. (for now)
function emacs.add_hook_intern(hook, func, func_name)
    expose_function(emacs_environment, func_name, "...", 0, false, func)
    emacs.run_no_return("add-hook", emacs.intern(hook), emacs.intern(func_name))
end

function emacs.make_local_variable(symbol)
    return emacs.run("make-local-variable", symbol)
end

function emacs.kbd(keys)
    return emacs.run("kbd", keys)
end

function emacs.define_key(keymap, key, def)
    emacs.run_no_return("define-key", keymap, key, def)
end

--- This function returns t if object is a symbol, nil otherwise.
function emacs.symbolp(object)
    return emacs.run("symbolp", object) ~= nil
end

--- This function returns the symbol in obarray whose name is name, or nil if obarray has no symbol with that name. Therefore, you can use intern-soft to test whether a symbol with a given name is already interned. If obarray is omitted, the value of the global variable obarray is used.
--- The argument name may also be a symbol; in that case, the function returns name if name is interned in the specified obarray, and otherwise nil.
function emacs.intern_soft(symbol_name)
    return emacs.run("intern-soft", symbol_name)
end

--- This is just a shorter function name for intern_soft.
--- Try to get a symbol from the emacs machine. Nil if it does not exist.
function emacs.get(symbol_name)
    return emacs.run("intern-soft", symbol_name)
end

--- This function returns the string that is symbol’s name.
function emacs.symbol_name(symbol)
    return emacs.run("symbol-name", symbol)
end

--- Check the equality of two symbols.
function emacs.eq(symbol_a, symbol_b)
    return emacs.run("eq", symbol_a, symbol_b) ~= nil
end

return emacs
