module emacs;

import bindbc.lua;
import core.stdc.stdlib;
import core.stdc.string;
import emacs_module;
import std.stdio;
import std.string;

/// Emacs has this thing where it needs to have this defined or it explodes.
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

struct LuaFunctionData {
    int reg_index;
    int nargs;
    int returns;
    lua_State* L; // TODO: use after free vulnerability?
}

/// Convert a lua 5.2 value to an emacs value.
emacs_value lua_to_emacs_val(emacs_env* env, lua_State* L, int stack_index) {
    switch (lua_type(L, stack_index)) {
    case LUA_TNIL: {
            return NIL(env);
        }
    case LUA_TNUMBER: {
            lua_Integer integer = lua_tointeger(L, stack_index);
            lua_Number num = lua_tonumber(L, stack_index);
            return integer != num ? env.make_float(env, num) : env.make_integer(env, integer);
        }
    case LUA_TBOOLEAN: {
            int boolean = lua_toboolean(L, stack_index);
            return boolean ? env.intern(env, "t") : NIL(env);
        }
    case LUA_TSTRING: {
            const char* thisString = lua_tostring(L, stack_index);
            return env.make_string(env, thisString, strlen(thisString));
        }
    case LUA_TUSERDATA: {
            emacs_value val = cast(emacs_value_tag*) lua_touserdata(L, stack_index);
            return val;
        }
    case LUA_TTABLE: {
            lua_getfield(L, -1, "type");
            const char* type = lua_tostring(L, -1);

            if (strcmp(type, "cons") == 0) {
                lua_getfield(L, -2, "car");
                emacs_value car = lua_to_emacs_val(env, L, -1);

                lua_getfield(L, -3, "cdr");
                emacs_value cdr = lua_to_emacs_val(env, L, -1);

                emacs_value[] args = [car, cdr];
                return env.funcall(env, env.intern(env, "cons"), 2, args.ptr);
            } else {
                writeln("Unknown table type");
                return NIL(env);
            }
        }
    default: {
            writeln("Unknown type");
            return NIL(env);
        }
    }
}

static ptrdiff_t emacs_get_string_length(emacs_env* env, emacs_value eval) {
    ptrdiff_t str_len = 0;
    if (!env.copy_string_contents(env, eval, null, &str_len)) {
        return -1;
    }
    return str_len;
}

// Convert a emacs lisp value to lua and push it onto the stack
static int emacs_to_lua_val(emacs_env* env, emacs_value eval, lua_State* L) {
    if (!env.is_not_nil(env, eval)) {
        lua_pushnil(L);
        return 0;
    }

    emacs_value type = env.type_of(env, eval);
    if (ELISP_IS_TYPE(env, type, "string")) {
        ptrdiff_t str_len;
        if ((str_len = emacs_get_string_length(env, eval)) < 0) {
            writeln("Failed to get string length");
            return -1;
        }

        char* str = cast(char*) malloc(str_len);
        if (!str) {
            writeln("Failed to allocate str");
            return -1;
        }

        if (!env.copy_string_contents(env, eval, str, &str_len)) {
            writeln("Failed to copy string");
            return -1;
        }

        lua_pushstring(L, str);
        free(str);
    } else if (ELISP_IS_TYPE(env, type, "integer")) {
        lua_pushinteger(L, env.extract_integer(env, eval));
    } else if (ELISP_IS_TYPE(env, type, "float")) {
        lua_pushnumber(L, env.extract_float(env, eval));
    } else if (ELISP_IS_TYPE(env, type, "boolean")) {
        // Redundant?
        if (env.eq(env, eval, env.intern(env, "nil"))) {
            lua_pushboolean(L, 0);
        } else {
            lua_pushboolean(L, 1);
        }
    } else if (ELISP_IS_TYPE(env, type, "symbol")) {
        emacs_value* l_udata = cast(emacs_value_tag**) lua_newuserdata(L, emacs_value.sizeof);
        memcpy(l_udata, eval, emacs_value.sizeof);
        return 0;
    } else if (ELISP_IS_TYPE(env, type, "cons")) {
        emacs_value[] args = [eval];
        emacs_value car = env.funcall(env, env.intern(env, "car"), 1, args.ptr);
        emacs_value cdr = env.funcall(env, env.intern(env, "cdr"), 1, args.ptr);

        lua_createtable(L, 3, 0);

        lua_pushstring(L, "cons");
        lua_setfield(L, -2, "type");

        auto _ = emacs_to_lua_val(env, car, L);
        lua_setfield(L, -2, "car");

        _ = emacs_to_lua_val(env, cdr, L);
        lua_setfield(L, -2, "cdr");

        return 0;
    } else {
        writeln("Unsupported type returned from emacs");
        return -1;
    }

    return 0;
}

/// Lua function. (with return)
/// Call emacs lisp function from lua 5.2.
static int functioncall(lua_State* L) {
    emacs_env* env = cast(emacs_env*) lua_touserdata(L, -4);
    const char* func_name = lua_tostring(L, -3);
    size_t nargs = cast(size_t) lua_tonumber(L, -2);

    if (nargs == 0) {
        emacs_value ret = env.funcall(env, env.intern(env, func_name), 0, null);
        if (emacs_to_lua_val(env, ret, L) < 0) {
            return 0;
        }
        return 1;
    }

    emacs_value* evalues = cast(emacs_value_tag**) malloc(emacs_value.sizeof * nargs);
    if (!evalues) {
        writeln("Failed to allocate evalues");
        return 0;
    }

    for (int i = 0; i < nargs; i++) {
        lua_rawgeti(L, -1 - i, i + 1);
        evalues[i] = lua_to_emacs_val(env, L, -1);
    }

    emacs_value ret = env.funcall(env, env.intern(env, func_name), nargs, evalues);
    if (emacs_to_lua_val(env, ret, L) < 0) {
        free(evalues);
        return 0;
    }

    free(evalues);
    return 1;
}

/// Lua function. (no return)
/// Call emacs lisp function from lua 5.2.
static int functioncall_no_return(lua_State* L) {
    emacs_env* env = lua_touserdata(L, -4);
    const char* func_name = lua_tostring(L, -3);
    size_t nargs = (size_t) lua_tonumber(L, -2);

    if (nargs == 0) {
        env -  > funcall(env, env -  > intern(env, func_name), 0, NULL);
        return 0;
    }

    emacs_value* evalues = malloc(sizeof(emacs_value) * nargs);
    if (!evalues) {
        LOG("Failed to allocate evalues");
        return 0;
    }

    for (size_t i = 0; i < nargs; i++) {
        lua_rawgeti(L, -1 - i, i + 1);
        evalues[i] = lua_to_emacs_val(env, L, -1);
    }

    env -  > funcall(env, env -  > intern(env, func_name), nargs, evalues);
    free(evalues);

    return 0;
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
