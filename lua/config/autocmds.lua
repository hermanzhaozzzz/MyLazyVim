-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- TSV: preserve tab characters, never expand to spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tsv",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 1
    vim.opt_local.shiftwidth = 1
    vim.opt_local.softtabstop = 0
  end,
  desc = "Preserve literal tab characters in TSV files",
})
