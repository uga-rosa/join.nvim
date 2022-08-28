local api = vim.api
local fn = vim.fn

local config = require("join.config")

local M = {}

---@param opt? table
function M.setup(opt)
    opt = opt or {}
    config.setup(opt)
    M.create_command()
end

function M.create_command()
    api.nvim_create_user_command("Join", function(opt)
        if opt.bang then
            vim.cmd(("%s,%sjoin!"):format(opt.line1, opt.line2))
        else
            local line1, line2 = opt.line1, opt.line2
            ---@type string
            local sep = opt.fargs[1] or config.get("sep")
            if opt.count == 0 then
                -- Call from normal mode
                local count = tonumber(opt.fargs[2]) or 0
                if count > 0 then
                    line2 = line2 + count
                else
                    line1 = line1 + count
                end
            end
            M._join(line1, line2, sep)
        end
    end, {
        nargs = "*",
        range = 0,
        bang = true,
    })
end

local user_input
user_input = {
    ---@param mode string
    ---@param default_value string | number
    ---@return string
    input = function(mode, default_value)
        local prompt = ("Input %s: "):format(mode)
        local result
        vim.cmd("redraw")
        vim.ui.input({
            prompt = prompt,
            default = default_value,
        }, function(input)
            result = input
        end)
        return result
    end,
    ---@param default_value string | number
    ---@return string
    noinput = function(_, default_value)
        return default_value .. ""
    end,
    ---@param mode string
    ---@param default_value string | number
    ---@return string
    select = function(mode, default_value)
        local prompt = ("Choice %ss: "):format(mode)
        local INPUT = "Input"
        local result
        ---@type string[]
        local sep_list = config.get("sep_list")
        table.insert(sep_list, INPUT)
        vim.cmd("redraw")
        vim.ui.select(sep_list, {
            prompt = prompt,
            format_item = function(item)
                return '"' .. item .. '"'
            end,
        }, function(choice)
            result = choice
        end)
        table.remove(sep_list)

        if result == INPUT then
            result = user_input.input(mode, default_value)
        end
        return result
    end,
}

local function feedkey(key)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, false, true), "nx", false)
end

---For <Plug> mapping.
---@param mode string
function M.map(mode)
    local is_normal = fn.mode() == "n"
    local get_user_input = user_input[mode] or user_input.input

    ---@type string
    local default_sep = config.get("sep")
    local sep = get_user_input("separator", default_sep) or ""

    local line1, line2
    if is_normal then
        -- Called from normal mode.
        line1 = fn.line(".")
        line2 = line1

        ---@type integer
        local default_count = config.get("count")
        if mode == "select" then
            get_user_input = user_input.input
        end
        local count = tonumber(get_user_input("count", default_count)) or 1

        if count > 0 then
            line2 = line2 + count
        else
            line1 = line1 + count
        end
    else
        -- Called from visual mode.
        feedkey("<Esc>")
        line1 = fn.line("'<")
        line2 = fn.line("'>")
    end

    M._join(line1, line2, sep)
end

---@param line string
---@return string
local function remove_suffix_whitespaces(line)
    return line:match("^(.*%S)") or ""
end

---@param line string
---@return string
local function remove_prefix_whitespaces(line)
    return line:match("^%s*(.*)$") or ""
end

---@param lines string[]
---@return string[]
local function format_for_join(lines, sep)
    lines[1] = remove_suffix_whitespaces(lines[1]) .. sep
    for i = 2, #lines - 1 do
        lines[i] = vim.trim(lines[i]) .. sep
    end
    lines[#lines] = remove_prefix_whitespaces(lines[#lines])
    return lines
end

---@param line1 integer
---@param line2 integer
---@param sep string
function M._join(line1, line2, sep)
    if line1 == line2 then
        return
    end

    -- 0-based index, and `end_` is exclusive.
    local lines = api.nvim_buf_get_lines(0, line1 - 1, line2, false)
    lines = format_for_join(lines, sep)
    api.nvim_buf_set_lines(0, line1 - 1, line2, false, lines)
    vim.cmd(("%s,%sjoin!"):format(line1, line2))
end

return M
