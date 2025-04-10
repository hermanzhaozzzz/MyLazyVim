-- Keymaps are automatically loaded on the VeryLazy event
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = vim.keymap.set

map("i", "jj", "<esc>l", { desc = "Escape", noremap = true, silent = true })

-- macos style go to start/end of line
map("i", "<C-a>", "<C-o>I", { desc = "Go to start of the line", noremap = true, silent = true })
map("i", "<C-e>", "<C-o>A", { desc = "Go to end of the line", noremap = true, silent = true })

-- FIXME 在 MacOS 中和任务调度快捷键冲突
-- Resize window using <ctrl> arrow keys
-- map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
-- map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
-- map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
-- map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
