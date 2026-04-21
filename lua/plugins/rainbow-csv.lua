local M = {}

M.ns = vim.api.nvim_create_namespace("table_aligned")
M.ns_sep = vim.api.nvim_create_namespace("table_header_sep")
M.enabled = false
M.pin_header = false
M.header_win = nil
M.timer = nil
M.widths = {}
M.augroup = vim.api.nvim_create_augroup("table_aligned", { clear = true })

--- Parse delimiter from filetype
---@return string
M.get_delimiter = function()
  if vim.bo.filetype == "tsv" then
    return "\t"
  end
  return ","
end

--- Calculate column widths from all buffer lines
M.recalc_widths = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local delim = M.get_delimiter()
  local widths = {}
  for _, line in ipairs(lines) do
    if line ~= "" then
      local cells = vim.split(line, delim, { plain = true })
      for i, cell in ipairs(cells) do
        widths[i] = math.max(widths[i] or 0, vim.fn.strdisplaywidth(cell))
      end
    end
  end
  M.widths = widths
end

--- Apply extmarks only to visible lines
M.apply_visible = function()
  local buf = 0
  local delim = M.get_delimiter()
  local delim_len = #delim
  local widths = M.widths
  local start_lnum = vim.fn.line("w0")
  local end_lnum = vim.fn.line("w$")

  for lnum = start_lnum, end_lnum do
    local line = vim.fn.getline(lnum)
    if line ~= "" then
      local cells = vim.split(line, delim, { plain = true })
      local byte_pos = 0
      for col_idx = 1, #cells - 1 do
        byte_pos = byte_pos + #cells[col_idx]
        local cell_w = vim.fn.strdisplaywidth(cells[col_idx])
        local max_w = widths[col_idx] or cell_w
        local padding = string.rep(" ", max_w - cell_w)

        vim.api.nvim_buf_set_extmark(buf, M.ns, lnum - 1, byte_pos, {
          conceal = "",
          virt_text = { { padding .. " │ ", "Comment" } },
          virt_text_pos = "inline",
          hl_mode = "replace",
        })

        byte_pos = byte_pos + delim_len
      end
    end
  end

  vim.wo.conceallevel = 2
  vim.wo.concealcursor = "nvc"
end

--- Clear all extmarks
M.clear_marks = function()
  vim.api.nvim_buf_clear_namespace(0, M.ns, 0, -1)
end

--- Debounced full recalc + reapply
M.schedule_update = function()
  if not M.enabled then
    return
  end
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  M.timer = vim.fn.timer_start(500, function()
    M.clear_marks()
    M.recalc_widths()
    M.apply_visible()
    if M.pin_header then
      M.apply_separator()
    end
    M.timer = nil
  end)
end

--- Close header float if it exists
M.close_header = function()
  if M.header_win and vim.api.nvim_win_is_valid(M.header_win) then
    vim.api.nvim_win_close(M.header_win, true)
  end
  M.header_win = nil
  vim.api.nvim_buf_clear_namespace(0, M.ns_sep, 0, -1)
end

--- Toggle in-place aligned editing
M.toggle_align = function()
  if M.enabled then
    M.enabled = false
    M.pin_header = false
    if M.timer then
      vim.fn.timer_stop(M.timer)
      M.timer = nil
    end
    M.close_header()
    M.clear_marks()
    vim.wo.conceallevel = 0
    vim.wo.concealcursor = ""
    vim.api.nvim_del_augroup_by_name("table_aligned")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines == 0 then
    return
  end
  if #lines > 5000 then
    if vim.fn.confirm("File has " .. #lines .. " rows. Continue?", "&Yes\n&No", 2) ~= 1 then
      return
    end
  end

  M.enabled = true
  M.augroup = vim.api.nvim_create_augroup("table_aligned", { clear = true })

  M.recalc_widths()
  M.apply_visible()

  -- Viewport change: reapply visible extmarks
  vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved" }, {
    group = M.augroup,
    buffer = 0,
    callback = function()
      M.clear_marks()
      M.apply_visible()
    end,
    desc = "Reapply alignment for visible lines on scroll",
  })

  -- Text change: debounced full recalc
  vim.api.nvim_create_autocmd("TextChanged", {
    group = M.augroup,
    buffer = 0,
    callback = function()
      M.schedule_update()
    end,
    desc = "Recalc column widths on text change",
  })
end

--- Build and apply separator virtual line below row 1
M.apply_separator = function()
  vim.api.nvim_buf_clear_namespace(0, M.ns_sep, 0, -1)
  local delim = M.get_delimiter()
  local cells = vim.split(vim.fn.getline(1), delim, { plain = true })
  local parts = {}
  for i, _ in ipairs(cells) do
    table.insert(parts, string.rep("─", M.widths[i] or 0))
  end
  local sep = table.concat(parts, "─┼─")
  vim.api.nvim_buf_set_extmark(0, M.ns_sep, 0, 0, {
    virt_lines = { { { sep, "Comment" } } },
  })
end

--- Toggle pinned header via floating window (ta mode only)
M.toggle_pin_header = function()
  if not M.enabled then
    return
  end

  if M.header_win and vim.api.nvim_win_is_valid(M.header_win) then
    M.close_header()
    M.pin_header = false
    return
  end

  M.pin_header = true

  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  local win_info = vim.fn.getwininfo(cur_win)[1]
  local textoff = win_info.textoff or 0
  local win_width = vim.api.nvim_win_get_width(cur_win) - textoff

  -- Build separator line from column widths
  M.apply_separator()

  local config = {
    relative = "win",
    win = cur_win,
    width = win_width,
    height = 1,
    row = 0,
    col = textoff,
    style = "minimal",
    focusable = false,
    zindex = 50,
  }
  M.header_win = vim.api.nvim_open_win(cur_buf, false, config)
  vim.api.nvim_win_set_cursor(M.header_win, { 1, 0 })
  vim.wo[M.header_win].wrap = false
  vim.wo[M.header_win].conceallevel = 2
  vim.wo[M.header_win].concealcursor = "nvc"
  vim.wo[M.header_win].number = false
  vim.wo[M.header_win].relativenumber = false
  vim.wo[M.header_win].signcolumn = "no"
  vim.wo[M.header_win].winhl = "Normal:Title"

  -- Sync horizontal scroll
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = M.augroup,
    callback = function()
      if not M.header_win or not vim.api.nvim_win_is_valid(M.header_win) then
        return true
      end
      local leftcol = vim.fn.winsaveview().leftcol
      vim.api.nvim_win_call(M.header_win, function()
        vim.fn.winrestview({ leftcol = leftcol, lnum = 1, topline = 1 })
      end)
    end,
  })
end

--- Insert a literal tab and enter insert mode (normal mode only)
M.insert_tab = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { "\t" })
  vim.api.nvim_win_set_cursor(0, { row, col + 2 })
  vim.cmd("startinsert")
end

return {
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv" },
    keys = {
      { "<leader>t", "", desc = "+table", mode = "n" },
      { "<leader>ta", function() M.toggle_align() end, desc = "Toggle in-place aligned editing", ft = { "csv", "tsv" } },
      { "<leader>th", function() M.toggle_pin_header() end, desc = "Toggle pinned header (ta only)", ft = { "csv", "tsv" } },
      { "<leader>ti", function() M.insert_tab() end, desc = "Insert literal tab", ft = { "csv", "tsv" } },
    },
  },
}
