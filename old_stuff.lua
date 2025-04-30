-- emacs.run("kill-buffer", emacs.run("get-buffer-create", "*Messages*"))

local test_buffer = em.run("get-buffer-create", "*test*")

em.run("switch-to-buffer", test_buffer)
em.run("insert-into-buffer", test_buffer)





-- print(em.run("symbol-value", em.intern("flarp")) ~= nil)

-- print(em.symbolp("flarp"))



-- local marker_point = em.intern("marker-point")

-- emacs.run("push-mark")
-- local start = emacs.run("region-beginning")
-- local ending = emacs.run("region-ending")
-- emacs.run("goto-char", start)
-- emacs.run("insert", "Hello from lua in D running in elisp! :D")

--! That's cool.
-- emacs.run("switch-to-buffer", emacs.run("get-buffer-create", "*scratch*"))


-- print("startup time: " .. em.emacs_init_time())

-- com.help_with_tutorial()
-- em.run(emacs_environment, "help-with-tutorial")

-- local function test_interactive()
--     emacs.run("print", "hi")
--     local x = emacs.run("read-number", "a:")
--     local y = emacs.run("read-number", "b:")

--     print(x + y)
--     print(num.zerop(x + y))
-- end



-- test_interactive()
