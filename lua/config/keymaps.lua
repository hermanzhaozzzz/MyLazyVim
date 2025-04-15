-- Keymaps are automatically loaded on the VeryLazy event
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = vim.keymap.set

map("i", "jj", "<esc>l", { desc = "Escape", noremap = true, silent = true })

-- macos style go to start/end of line
map("i", "<C-a>", "<C-o>I", { desc = "Go to start of the line", noremap = true, silent = true })
map("n", "<C-a>", "^", { desc = "Go to start of the line", noremap = true, silent = true })
map("v", "<C-a>", "^", { desc = "Go to start of the line", noremap = true, silent = true })
map("i", "<C-e>", "<C-o>A", { desc = "Go to end of the line", noremap = true, silent = true })
map("n", "<C-e>", "$", { desc = "Go to end of the line", noremap = true, silent = true })
map("v", "<C-e>", "$", { desc = "Go to end of the line", noremap = true, silent = true })

-- FIXME 在 MacOS 中和任务调度快捷键冲突
-- Resize window using <ctrl> arrow keys
map("n", "<leader>z<Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<leader>z<Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<leader>z<Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<leader>z<Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Neovide mappings
if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.g.neovide_hide_mouse_when_typing = true
  -- Neovide mappings
  local function adjust_neovide_scale(adjustment)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + adjustment
  end

  map("n", "<leader>zi", function()
    adjust_neovide_scale(0.1)
  end, { silent = true, nowait = true, desc = "For Neovide: Zoom in" })
  map("n", "<leader>zo", function()
    adjust_neovide_scale(-0.1)
  end, { silent = true, nowait = true, desc = "For Neovide: Zoom out" })
  map("n", "<leader>zr", function()
    vim.g.neovide_scale_factor = 1
  end, { silent = true, nowait = true, desc = "For Neovide: Reset zoom" })
end
