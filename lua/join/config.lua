local M = {}

M.config = {
    sep = ", ",
    count = 0,
}

---@param opt table
function M.setup(opt)
    vim.tbl_deep_extend("force", M.config, opt)
end

---@param name string
---@return any
function M.get(name)
    return M.config[name]
end

return M
