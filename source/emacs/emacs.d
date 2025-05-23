module emacs.emacs;

import emacs.emacs_module;
import main;
import std.string;

emacs_env* env;

// pragma(msg, "hello from compiler");

/// Emacs has this thing where it needs to have this defined or it explodes.
export extern (C) __gshared int plugin_is_GPL_compatible;

/// Return nil to elisp from D.
pragma(inline, true)
emacs_value NIL(emacs_env* env) {
    return env.intern(env, "nil");
}

/// Define an elisp function.
void defun(int mm_arity, emacs_function func, string docstring, string symbol_name) {

    emacs_value efunc =
        env.make_function(env, mm_arity, mm_arity, func, docstring.toStringz(), NULL);
    emacs_value symbol = env.intern(env, symbol_name.toStringz());
    emacs_value[] args = [symbol, efunc];
    env.funcall(env, env.intern(env, "defalias"), 2, args.ptr);
}

/// This is the main module initialization.
/// This is automatically called by Emacs.
export extern (C) __gshared int emacs_module_init(emacs_runtime* runtime) {
    env = runtime.get_environment(runtime);
    defun(0, &terminate, "Terminate the Vmacs lua plugin", "terminate-vmacs");
    dMain();
    return 0;
}

/// Terminate.
export extern (C) __gshared emacs_value terminate(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {

    dTerminate();
    return NIL(env);
}
