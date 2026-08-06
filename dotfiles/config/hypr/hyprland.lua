-- Split into multiple files (see wiki: Configuring/Start).
-- Each require() is its own Lua scope — locals don't leak between files.

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.33",
})

require("env")
require("look")
require("input")
require("binds")
require("windowrules")