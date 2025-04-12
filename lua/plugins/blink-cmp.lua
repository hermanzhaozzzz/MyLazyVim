-- https://github.com/Saghen/blink.cmp/issues/1367
-- Helper function to check if there's a word before the cursor.
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return text:sub(col, col):match("%s") == nil
end

return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  version = "*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    keymap = {
      preset = "none",

      ["<Tab>"] = {
        function(cmp)
          local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
          local char_undor_cursor = vim.api.nvim_get_current_line():sub(cursor_col, cursor_col)
          -- Fallback to the default behavior, if on whitespace
          if not has_words_before() then
            return

          -- Request and show the first item, if we have no items
          elseif #cmp.get_items() == 0 then
            cmp.show_and_insert()

          -- Otherwise, select the next item
          else
            vim.schedule(function()
              require("blink.cmp.completion.list").select_next()
            end)
          end
          return true
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
          local char_undor_cursor = vim.api.nvim_get_current_line():sub(cursor_col, cursor_col)
          -- Fallback to the default behavior, if on whitespace
          if not has_words_before() then
            return

          -- Cancel if we're on the first item
          elseif cmp.get_selected_item_idx() == 1 then
            vim.schedule(function()
              require("blink.cmp.completion.list").undo_preview()
              require("blink.cmp.completion.trigger").hide()
            end)

          -- Otherwise, select prev
          else
            vim.schedule(function()
              require("blink.cmp.completion.list").select_prev()
            end)
          end
          return true
        end,
        "fallback",
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      -- default = { "lsp", "path", "snippets", "buffer" },
      default = { "buffer", "lsp" },
    },

    completion = {
      menu = { enabled = false },
      ghost_text = {
        enabled = true,
        -- Show the ghost text when no item has been selected, defaulting to the first item
        show_without_selection = true,
      },
      list = { selection = { preselect = false } },
    },
  },
  opts_extend = { "sources.default" },
}
