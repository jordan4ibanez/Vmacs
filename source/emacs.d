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
        // Customized type to handle things like windows.
        writeln("warning: unknown type, might cause crash.");

        emacs_value* l_udata = cast(emacs_value_tag**) lua_newuserdata(L, emacs_value.sizeof);
        memcpy(l_udata, eval, emacs_value.sizeof);
        return 0;

        // writeln("Unsupported type returned from emacs");
        // return -1;
    }

    return 0;
}

/// Lua function. (with return)
/// Call emacs lisp function from lua 5.2.
static extern (C) __gshared int functioncall(lua_State* L) {
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
static extern (C) __gshared int functioncall_no_return(lua_State* L) {
    emacs_env* env = cast(emacs_env_29*) lua_touserdata(L, -4);
    const char* func_name = lua_tostring(L, -3);
    size_t nargs = cast(size_t) lua_tonumber(L, -2);

    if (nargs == 0) {
        env.funcall(env, env.intern(env, func_name), 0, null);
        return 0;
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

    env.funcall(env, env.intern(env, func_name), nargs, evalues);
    free(evalues);

    return 0;
}

static extern (C) __gshared emacs_value lua_function_proxy(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    LuaFunctionData* dat = cast(LuaFunctionData*) data;
    if (dat.nargs != nargs) {
        return NIL(env);
    }

    lua_pushlightuserdata(dat.L, env);
    lua_setglobal(dat.L, "emacs_environment");
    lua_pop(dat.L, -1);

    lua_rawgeti(dat.L, LUA_REGISTRYINDEX, dat.reg_index);

    for (int i = 0; i < dat.nargs; i++) {
        auto _ = emacs_to_lua_val(env, args[i], dat.L);
    }

    lua_call(dat.L, dat.nargs, dat.returns);

    if (dat.returns) {
        return lua_to_emacs_val(env, dat.L, -1);
    }

    return NIL(env);
}

static extern (C) __gshared int expose_function(lua_State* L) {
    emacs_env* env = cast(emacs_env_29*) lua_touserdata(L, -6);
    const char* lisp_fname = lua_tostring(L, -5);
    const char* docstring = lua_tostring(L, -4);
    int nargs = cast(int) lua_tointeger(L, -3);
    int returns = lua_toboolean(L, -2);
    int function_reg_index = luaL_ref(L, LUA_REGISTRYINDEX);

    // TODO: It leaks: 
    // todo: use the gc so this isn't a disaster
    LuaFunctionData* data = cast(LuaFunctionData*) malloc(LuaFunctionData.sizeof);
    data.reg_index = function_reg_index;
    data.nargs = nargs;
    data.returns = returns;
    data.L = L;

    emacs_value efunc = env.make_function(env, nargs, nargs, &lua_function_proxy,
        docstring, data);
    emacs_value symbol = env.intern(env, lisp_fname);
    emacs_value[] args = [symbol, efunc];
    env.funcall(env, env.intern(env, "defalias"), 2, args.ptr);

    return 0;
}

void terminateLuaState() {
    lua_close(state);
    state = null;
    writeln("Lua 5.2 state terminated.");
}

void initializeLuaState() {
    state = luaL_newstate();
    luaL_openlibs(state);
    writeln("Lua 5.2 state initialized");

    // todo: fix this. This is insanely dangerous.
    // fixme: this is insanely dangerous.
    alias BAD_IDEA = extern (C) int function(lua_State*) nothrow;

    lua_pushcfunction(state, cast(BAD_IDEA)&functioncall);
    lua_setglobal(state, "functioncall");

    lua_pushcfunction(state, cast(BAD_IDEA)&functioncall_no_return);
    lua_setglobal(state, "functioncall_no_return");

    lua_pushcfunction(state, cast(BAD_IDEA)&expose_function);
    lua_setglobal(state, "expose_function");
}

static emacs_value executeLuaStr(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    cast(void) env;
    cast(void) data;

    if (nargs < 2) {
        writeln("Missing arguments");
        return NIL(env);
    }

    ptrdiff_t code_len;
    if ((code_len = emacs_get_string_length(env, args[1])) < 0) {
        writeln("Failed to get code len");
        return NIL(env);
    }

    char* lua_code = cast(char*) malloc(code_len);
    if (!lua_code) {
        writeln("Failed to allocate lua_code");
        return NIL(env);
    }

    if (!env.copy_string_contents(env, args[1], lua_code, &code_len)) {
        writeln("Failed to copy lua code");
        return NIL(env);
    }

    lua_State* L = cast(lua_State*) env.get_user_ptr(env, args[0]);

    // Expose the emacs environment for use in Lua
    lua_pushlightuserdata(L, env);
    lua_setglobal(L, "emacs_environment");
    lua_pop(L, -1);

    if (luaL_dostring(L, lua_code)) {
        printf("LUAMACS(execute_lua_str) Error occured running lua code: %s\n",
            lua_tostring(L, -1));
        return NIL(env);
    }

    free(lua_code);
    return NIL(env);
}

/// Execute a lua file.
static extern (C) __gshared emacs_value executeLuaFile(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    cast(void) env;
    cast(void) data;

    if (nargs < 1) {
        writeln("Missing arguments");
        return NIL(env);
    }

    ptrdiff_t code_len;
    if ((code_len = emacs_get_string_length(env, args[0])) < 0) {
        writeln("Failed to get code len");
        return NIL(env);
    }

    char* file_location = cast(char*) malloc(code_len);
    if (!file_location) {
        writeln("Failed to allocate file_location");
        return NIL(env);
    }

    if (!env.copy_string_contents(env, args[0], file_location, &code_len)) {
        writeln("Failed to copy file location");
        return NIL(env);
    }

    // Expose the emacs environment for use in Lua
    lua_pushlightuserdata(state, env);
    lua_setglobal(state, "emacs_environment");
    lua_pop(state, -1);

    if (luaL_dofile(state, file_location)) {
        printf("LUAMACS(execute_lua_str) Error occured running lua code: %s\n",
            lua_tostring(state, -1));
    }

    free(file_location);
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
    initializeLuaState();
}

/// Shuts down the lua 5.2 state. (also I like to thank people for using vmacs)
export extern (C) __gshared emacs_value terminate(emacs_env* env, ptrdiff_t nargs,
    emacs_value* args, void* data) {
    terminateLuaState();
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

    defun(env, 1, &executeLuaFile, "Execute a lua file", "run-lua-file");

    // executeLuaFile(env, "./init.lua");

    return 0;
}
