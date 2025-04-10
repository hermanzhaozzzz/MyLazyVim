local has_words_before = function(...) -- 允许接收任意参数
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
        preset = "none",
        ["<Tab>"] = {
          function(cmp)
            if has_words_before() then -- 此处调用时未传参，但函数已兼容
              return cmp.insert_next()
            end
          end,
          "fallback",
        },
        -- 其他键位配置保持不变
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
