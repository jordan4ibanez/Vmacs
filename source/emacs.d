module emacs;

import emacs_module;
import std.stdio;

export extern (C) __gshared int plugin_is_GPL_compatible;

void test_d() {
    writeln("Edit source/app.d to start your project.");
}

static void defun(emacs_env* env, int mm_arity, emacs_function func,
    const char* docstring, const char* symbol_name) {

    emacs_value efunc =
        env.make_function(env, mm_arity, mm_arity, func, docstring, NULL);
    emacs_value symbol = env.intern(env, symbol_name);
    emacs_value[] args = [symbol, efunc];
    env.funcall(env, env.intern(env, "defalias"), 2, args.ptr);
}

export extern (C) __gshared int emacs_module_init(emacs_runtime* runtime) {
    emacs_env* env = runtime.get_environment(runtime);

    // defun(env, 0, state_init, "Initialize the lua state", "luamacs-state-init");
    // defun(env, 2, execute_lua_str, "Execute a given string containing lua code",

    // "luamacs-exec-str");
    // LOG("Initialized");

    writeln("hi");

    return 0;
}
