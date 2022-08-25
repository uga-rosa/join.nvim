# join.nvim

`:join` (or `J` in normal mode) with selectable delimiters.

You can use the feature of this plugin via commands or key mappings.

![join nvim](https://user-images.githubusercontent.com/82267684/186750604-eeb41908-e046-4601-b8c9-f5f1d0922f01.gif)

# Setup

If you use the default settings, there is NO need to call the setup function. Just install and use.
Below is an example of redefining the default settings.

```lua
require("join").setup({
    sep = " ",
    count = 0,
})
```

# Command

- `:[range]Join[!] [{sep} [{count}]]`
    - Join the selected lines with `{sep}`.
    - If you want to use spaces in a delimiter, please escape them with `\`.
    - The `{count}` is the offset of the last row. Negative numbers mean upward.
    - For example, if `:Join , -2`, then the current row and the top two rows, a total of three rows, are joined by `,`.
    - With `[!]`, this command does not insert or delete any spaces (Same as `:join!`).
    - If `{sep}` and/or `{count}` are omitted, the ones defined in setup will be used (Defaults are `, ` and `0`).

# Mapping

- `<Plug>(join-input)`
    - Defined in `n` and `x` mode.
    - Use `input()` to enter `{sep}` and `{count}`.
    - In visual mode (xmap), the input of `{count}` is omitted.
- `<Plug>(join-getchar)`
    - Defined in `n` and `x` mode.
    - Use `getcharstr()` to enter `{sep}` and `{count}`.
    - In visual mode (xmap), the input of `{count}` is omitted.
- `<Plug>(join-noinput)`
    - Defined in `n` and `x` mode.
    - Don't input, use default `{sep}` and `{count}`.
