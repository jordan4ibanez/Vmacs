local em = require("emacs")

local string = {}

---     This predicate function does what string-match does, but it avoids modifying the match data.
function string.string_match_p(regexp, str, optional, start)
    return em.run("string-match-p", regexp, str, optional, start)
end

return string;
