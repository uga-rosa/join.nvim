local fn = vim.fn

local M = {}

M.config = {
    sep = " ",
    count = 0,
    ---@type table<string, fun(prompt: string, default_value: string | number)>
    get_user_input = {
        input = function(prompt, default_value)
            local result
            vim.ui.input({
                prompt = prompt,
                default = default_value,
            }, function(input)
                result = input
            end)
            return result
        end,
        getchar = function()
            return fn.getcharstr()
        end,
        noinput = function(_, default)
            return default
        end,
    },
}

---@param opt table
function M.setup(opt)
    vim.tbl_deep_extend("force", M.config, opt)
end

return M
