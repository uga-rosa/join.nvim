# join.nvim

`join()` (or `J` in normal mode) with selectable delimiters.

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
    - Combines the selected range with {sep}.
    - If {sep} and/or {count} are omitted, the ones defined in setup will be used (Defaults are ", " and 0).
    - The count is the offset of the last row. Negative numbers mean upward.
    - For example, if `:Join , -2`, then the current row and the top two rows, a total of three rows, are joined by `,`.
    - If you want to use special characters as separator, please escape them with `\`.
    - This command does not insert or delete any spaces with [!]. (Same as `:join!`)
