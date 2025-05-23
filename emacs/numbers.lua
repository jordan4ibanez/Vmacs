--- Number related functions.

local em = require("emacs")

local num = {}

--- This predicate tests whether its argument is a large integer, and returns t if so, nil otherwise. Unlike small integers, large integers can be = or eql even if they are not eq.
function num.bignump(object)
    return em.run("bignump", object) ~= nil
end

--- This predicate tests whether its argument is a small integer, and returns t if so, nil otherwise. Small integers can be compared with eq.
function num.fixnump(object)
    return em.run("fixnump", object) ~= nil
end

--- This predicate tests whether its argument is floating point and returns t if so, nil otherwise.
function num.floatp(object)
    return em.run("floatp", object) ~= nil
end

--- This predicate tests whether its argument is an integer, and returns t if so, nil otherwise.
function num.integerp(object)
    return em.run("integerp", object) ~= nil
end

--- This predicate tests whether its argument is a number (either integer or floating point), and returns t if so, nil otherwise.
function num.numberp(object)
    return em.run("numberp", object) ~= nil
end

--- This predicate (whose name comes from the phrase “natural number”) tests to see whether its argument is a nonnegative integer, and returns t if so, nil otherwise. 0 is considered non-negative.
--- wholenump is a synonym for natnump.
function num.natnump(object)
    return em.run("natnump", object) ~= nil
end

--- This predicate tests whether its argument is zero, and returns t if so, nil otherwise. The argument must be a number.
--- (zerop x) is equivalent to (= x 0).
function num.zerop(object)
    return em.run("zerop", object) ~= nil
end

---This function acts like eq except when both arguments are numbers. It compares numbers by type and numeric value, so that (eql 1.0 1) returns nil, but (eql 1.0 1.0) and (eql 1 1) both return t. This can be used to compare large integers as well as small ones. Floating-point values with the same sign, exponent and fraction are eql. This differs from numeric comparison: (eql 0.0 -0.0) returns nil and (eql 0.0e+NaN 0.0e+NaN) returns t, whereas = does the opposite.
function num.eql(a, b)
    return em.run("eql", a, b) ~= nil
end

return num
