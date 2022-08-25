# join.nvim

`:join` (or `J` in normal mode) with selectable delimiters.

![join nvim](https://user-images.githubusercontent.com/82267684/186750604-eeb41908-e046-4601-b8c9-f5f1d0922f01.gif)

# Setup

If you use the default settings, there is NO need to call the setup function. Just install and use.
Below is an example of redefining the default settings.

```lua
require("join").setup({
    sep = ", ",
    count = 0,
})
```

# Command

- `:[range]Join[!] [{sep} [{count}]]`
    - Combines the selected range with `{sep}`.
    - If you want to use spaces in a delimiter, please escape them with `\`.
    - The `{count}` is the offset of the last row. Negative numbers mean upward.
    - For example, if `:Join , -2`, then the current row and the top two rows, a total of three rows, are joined by `,`.
    - With `[!]`, this command does not insert or delete any spaces (Same as `:join!`).
    - If `{sep}` and/or `{count}` are omitted, the ones defined in setup will be used (Defaults are `, ` and `0`).
