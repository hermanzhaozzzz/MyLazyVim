return {
  "hkupty/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { "zsh" },
          },
          python = {
            command = { "ipython", "--no-autoindent" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
        },
        -- See below for more information
        repl_open_cmd = require("iron.view").right("%40"),
      },
      keymaps = {
        toggle_repl = "<space>rr", -- toggles the repl open and closed.
        restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
        send_motion = "<space>rc",
        visual_send = "<space>rc",
        send_code_block = "<space>rb",
        send_code_block_and_move = "<space>rn",
        send_file = "<space>rf",
        send_line = "<space>rl",
        send_mark = "<space>rm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>r<cr>",
        interrupt = "<space>ri",
        exit = "<space>rq",
        clear = "<space>rL",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })
  end,
}
