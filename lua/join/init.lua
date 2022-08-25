local api = vim.api

local config = require("join.config")

local M = {}

function M.setup(opt)
    opt = opt or {}
    config.setup(opt)
    M.create_command()
end

function M.create_command()
    api.nvim_create_user_command("Join", function(opt)
        local bang = opt.bang
        if bang then
            vim.cmd("normal! gv")
            vim.cmd("normal! gJ")
        else
            local sep = opt.fargs[1] or config.get("sep")
            local count = opt.fargs[2] or 0
            local line1, line2 = opt.line1, opt.line2 + count
            if line1 > line2 then
                line1, line2 = line2, line1
            end
            M.join(line1, line2, sep)
        end
    end, {
        nargs = "*",
        range = true,
        bang = true,
    })
end

function M.join(line1, line2, sep)
    -- 0-based index, and `end_` is exclusive.
    local lines = api.nvim_buf_get_lines(0, line1 - 1, line2, false)

    local cms = vim.opt.commentstring:get()
    cms = cms:gsub(".", "%%%1")
    cms = cms:gsub("%%%%%%s", "(.*)")
    cms = "^" .. cms .. "$"

    local in_comment = lines[1]:find(cms) and true or false
    for i = 2, #lines do
        local line = lines[i]
        line = vim.trim(line)
        if in_comment and line:find(cms) then
            line = line:match(cms)
            line = vim.trim(line)
        end
        lines[i] = line
    end

    local new_line = table.concat(lines, sep)
    api.nvim_buf_set_lines(0, line1 - 1, line2, false, { new_line })
end

return M
