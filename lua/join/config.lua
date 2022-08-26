local M = {}

M.config = {
    sep = " ",
    sep_list = {
        " ",
        ", ",
    },
    count = 0,
}

---@param opt table
function M.setup(opt)
    vim.tbl_deep_extend("force", M.config, opt)
end

return M
