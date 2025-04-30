local em = require("emacs")

local str = {}

--- This predicate function does what string-match does, but it avoids modifying the match data.
function str.string_match_p(regexp, s, start)
    return em.run("string-match-p", regexp, s, start) ~= nil
end

return str;
