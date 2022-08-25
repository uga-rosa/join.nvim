local api = vim.api
local fn = vim.fn

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
            vim.cmd("normal! gvgJ")
        else
            local sep = opt.fargs[1] or config.get("sep")
            local count = opt.fargs[2] or 0
            local line1, line2 = opt.line1, opt.line2 + count
            if line1 > line2 then
                line1, line2 = line2, line1
            end
            M._join(line1, line2, sep)
        end
    end, {
        nargs = "*",
        range = true,
        bang = true,
    })
end

local function _get_user_input(use_input)
    if use_input then
        return fn.input
    else
        return function(_, _, _)
            return fn.getcharstr()
        end
    end
end

local function feedkey(key)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, false, true), "nx", false)
end

function M.map(is_normal, use_input)
    local get_user_input = _get_user_input(use_input)

    local default_sep = config.get("sep") or ""
    local sep = get_user_input("Input separator: ", default_sep)

    local line1, line2
    if is_normal then
        -- Called from normal mode.
        local default_count = config.get("count")
        if default_count == 0 then
            default_count = ""
        end
        local count_input = get_user_input("Input count: ", default_count)
        local count = tonumber(count_input) or 0
        if count == 0 then
            return
        elseif count > 0 then
            line1 = fn.line(".")
            line2 = line1 + count
        else
            line2 = fn.line(".")
            line1 = line1 + count
        end
    else
        -- Called from visual mode.
        feedkey("<Esc>")
        line1 = fn.line("'<")
        line2 = fn.line("'>")
        if line1 == line2 then
            return
        end
    end

    M._join(line1, line2, sep)
end

function M._join(line1, line2, sep)
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
