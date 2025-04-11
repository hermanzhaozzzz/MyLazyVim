local has_words_before = function()
  -- 使用 function(...) 或显式声明参数数量，避免因隐式传参导致崩溃
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  -- 直接获取完整当前行内容 vim.api.nvim_get_current_line()，无需 :sub()
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%s") == nil
end
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          function(cmp)
            if has_words_before() then -- 此处调用时未传参，但函数已兼容
              return cmp.insert_next()
            end
          end,
          "fallback",
        },
        -- Navigate to the previous suggestion or cancel completion if currently on the first one.
        ["<S-Tab>"] = { "insert_prev" },
      },
      completion = {
        menu = { enabled = true },
        list = {
          selection = { preselect = true },
          cycle = { from_top = true },
        },
      },
      fuzzy = { implementation = "lua" },
    },
  },
}
