module emacs;

import emacs_module;
import std.stdio;
import std.string;

pragma(msg, "hello from compiler");

/// Emacs has this thing where it needs to have this defined or it explodes.
export extern (C) __gshared int plugin_is_GPL_compatible;

/// Return nil to elisp from D.
pragma(inline, true)
emacs_value NIL(emacs_env* env) {
    return env.intern(env, "nil");
}

/// Shuts down the lua 5.2 state. (also I like to thank people for using vmacs)
export extern (C) __gshared emacs_value terminate(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    // terminateLuaState();
    writeln("Thank you for using VMACS! :)");
    return NIL(env);
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

/// This is the main module initialization.
/// This is automatically called by Emacs.
export extern (C) __gshared int emacs_module_init(emacs_runtime* runtime) {
    emacs_env* env = runtime.get_environment(runtime);

    writeln("hello from D!");

    defun(env, 0, &terminate, "Terminate the Vmacs lua plugin", "terminate-vmacs");

    return 0;
}
