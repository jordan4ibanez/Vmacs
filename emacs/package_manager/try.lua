--- Number related functions.

-- Copyright (C) 2014 Lars Tveito.

-- Author: Lars Tveito <larstvei@ifi.uio.no>
-- URL: http://github.com/larstvei/try
-- Created: 13th November 2014
-- Keywords: packages
-- Version: 0.0.1
-- Package-Requires: ((emacs "24"))

-- Contains code from GNU Emacs <https://www.gnu.org/software/emacs/>,
-- released under the GNU General Public License version 3 or later.

-- Try is free software; you can redistribute it and/or modify it under the
-- terms of the GNU General Public License as published by the Free Software
-- Foundation; either version 3, or (at your option) any later version.
--
-- Try is distributed in the hope that it will be useful, but WITHOUT ANY
-- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
-- details.
--
-- You should have received a copy of the GNU General Public License along
-- with Try. If not, see <http://www.gnu.org/licenses/>.

--; Commentary:

-- Try is a package that allows you to try out Emacs packages without
-- installing them. If you pass a URL to a plain text `.el`-file it evaluates
-- the content, without storing the file.

-- For more info see https://github.com/larstvei/Try

local em = require("emacs")
local str = require("str")

em.require_interned("package")
em.require_interned("url")

local try = {}

--- Returns non-nil if this looks like an URL to a .el file.
function try.raw_link_p(url)
    str.string_match_p("[^:]*://\\([^?\r\n]+\\).*\\.el?$", url)
end

return try;
