module emacs;

import bindbc.lua;
import emacs_module;
import std.stdio;
import std.string;

export extern (C) __gshared int plugin_is_GPL_compatible;

/// The Lua 5.2 state.
__gshared lua_State* state;

/// Return nil to elisp from D.
pragma(inline, true)
emacs_value NIL(emacs_env* env) {
    return env.intern(env, "nil");
}

/// Typecheck for elisp.
pragma(inline, true)
bool ELISP_IS_TYPE(emacs_env* env, emacs_value type, string str) {
    return env.eq(env, env.intern(env, str.toStringz()), type);
}

/// Define an elisp function.
void defun(emacs_env* env, int mm_arity, emacs_function func,
    string docstring, string symbol_name) {

    emacs_value efunc =
        env.make_function(env, mm_arity, mm_arity, func, docstring.toStringz(), NULL);
    emacs_value symbol = env.intern(env, symbol_name.toStringz());
    emacs_value[] args = [symbol, efunc];
    env.funcall(env, env.intern(env, "defalias"), 2, args.ptr);
}

/// Initializes the shared library along with the lua 5.2 state.
void initLua() {
    LuaSupport ret = loadLua();
    if (ret != luaSupport) {
        if (ret == luaSupport.noLibrary) {
            throw new Error("Lua: no library.");
            // Lua shared library failed to load
        } else if (luaSupport.badLibrary) {
            throw new Error("Lua: bad library.");
            // One or more symbols failed to load. The likely cause is that the
            // shared library is a version different from the one the app was
            // configured to load
        }
    }
    state = luaL_newstate();
}

/// Shuts down the lua 5.2 state. (also I like to thank people for using vmacs)
export extern (C) __gshared emacs_value terminate(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    lua_close(state);
    writeln("Thank you for using VMACS! :)");
    return NIL(env);
}

/// This is the main module initialization.
/// This is automatically called by Emacs.
export extern (C) __gshared int emacs_module_init(emacs_runtime* runtime) {
    emacs_env* env = runtime.get_environment(runtime);

    writeln("hello from D!");

    initLua();

    defun(env, 0, &terminate, "Terminate the Vmacs lua plugin", "terminate-vmacs");

    // defun(env, 0, state_init, "Initialize the lua state", "luamacs-state-init");
    // defun(env, 2, execute_lua_str, "Execute a given string containing lua code",
    // "luamacs-exec-str");

    // LOG("Initialized");

    return 0;
}
