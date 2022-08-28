local M = {}

M.config = {
    sep = " ",
    sep_list = {
        " ",
        ", ",
    },
    count = 1,
}

---@param opt table
function M.setup(opt)
    vim.tbl_deep_extend("force", M.config, opt)
end

---@param name string
---@return any
function M.get(name)
    return M.config[name] or error("Invalid name of config: " .. name, 2)
end

return M
