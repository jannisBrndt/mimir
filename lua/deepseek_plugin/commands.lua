local M = {}

-- If you're stripping ANSI codes for normal usage, keep that function:
local function strip_ansi_codes(str)
  return str:gsub("\27%[%??[%d;]*[A-Za-z]", "")
end

-- Original synchronous search (just for reference)
function M.search(query, deepseek_cmd)
  if not query or query == "" then
    print("DeepSeek requires a query argument.")
    return
  end
  local cmd = string.format('%s "%s"', deepseek_cmd, query)
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("DeepSeek command failed:")
    print(strip_ansi_codes(output))
    return
  end

  print(strip_ansi_codes(output))
end

--------------------------------------------------------
-- NEW: Search in a floating terminal
--------------------------------------------------------
function M.search_in_floating_term(query, deepseek_cmd)
  if not query or query == "" then
    print("DeepSeek requires a query argument.")
    return
  end

  -- We'll build a single shell command that includes your search query
  local full_cmd = string.format('%s "%s"', deepseek_cmd, query)

  -- 1) Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true) -- (listed=false, scratch=true)
  if buf == 0 then
    print("Failed to create buffer for floating terminal.")
    return
  end

  -- 2) Determine floating window size & position
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- 3) Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",  -- or "single" / "double" / "solid" / etc.
  })

  -- OPTIONAL: Set some buffer/window options, e.g. no number lines:
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")

  -- 4) Start a terminal in the new buffer and run your command
  vim.fn.termopen(full_cmd)

  -- (Optional) You could define a keymapping to close the floating window:
  -- e.g. pressing <ESC> in terminal mode:
  --    vim.api.nvim_buf_set_keymap(buf, 't', '<ESC>', '<C-\\><C-n>:q<CR>', { nowait=true, noremap=true, silent=true })
end

return M
