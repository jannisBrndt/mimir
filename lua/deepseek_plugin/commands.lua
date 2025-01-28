local M = {}

-- (Existing function that strips ANSI codes, if you have it)
local function strip_ansi_codes(str)
  return str:gsub("\27%[%??[%d;]*[A-Za-z]", "")
end

-- Use this function to get the text currently highlighted in Visual mode.
local function get_visual_selection()
  -- 1. Save the current unnamed register ("") contents/types
  local saved_reg = vim.fn.getreg('"')
  local saved_regtype = vim.fn.getregtype('"')

  -- 2. Yank the visually selected text into register 'x'
  --    Using "normal! gv" ensures we re-select the last visual area
  vim.cmd('normal! gv"xy')

  -- 3. Retrieve the yanked text
  local selection = vim.fn.getreg('x')

  -- 4. Restore the unnamed register
  vim.fn.setreg('"', saved_reg, saved_regtype)

  return selection
end

-- The original search function (unchanged) -----------------------------------
function M.search(query, deepseek_cmd)
  if not query or query == "" then
    print("DeepSeek requires a query argument.")
    return
  end

  -- Example of building the command; strip ANSI codes if desired
  local cmd = string.format('%s "%s"', deepseek_cmd, query)
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("DeepSeek command failed:")
    print(strip_ansi_codes(output))
    return
  end

  print(strip_ansi_codes(output))
end

-- New function for searching highlighted text -------------------------------
function M.search_visual(deepseek_cmd)
  local selection = get_visual_selection()
  if not selection or selection == "" then
    print("No text selected.")
    return
  end
  -- Reuse the same `search()` logic
  M.search(selection, deepseek_cmd)
end

return M
