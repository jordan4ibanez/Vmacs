local em = require("emacs")

local str = {}

---     This predicate function does what string-match does, but it avoids modifying the match data.
function str.string_match_p(regexp, str, optional, start)
    return em.run("string-match-p", regexp, str, optional, start)
end

return str;
