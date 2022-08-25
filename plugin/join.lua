if vim.g.loaded_join then
    return
end

local join = require("join")

join.create_command()

vim.keymap.set({ "n", "x" }, "<Plug>(join-input)", function()
    join.map("input")
end)
vim.keymap.set({ "n", "x" }, "<Plug>(join-getchar)", function()
    join.map("getchar")
end)
vim.keymap.set({ "n", "x" }, "<Plug>(join-noinput)", function()
    join.map("noinput")
end)
