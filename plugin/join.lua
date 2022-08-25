if vim.g.loaded_join then
    return
end

local join = require("join")
local fn = vim.fn

vim.keymap.set({ "n", "x" }, "<Plug>(join-input)", function()
    join.map(fn.mode() == "n", true)
end)
vim.keymap.set({ "n", "x" }, "<Plug>(join-getchar)", function()
    join.map(fn.mode() == "n", false)
end)

join.setup()
