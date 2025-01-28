local M = {}

-- A helper function to remove most ANSI/VT100 escape sequences
-- from a given string, such as ^[[?25l, ^[[?25h, ^[[1G, etc.
local function strip_ansi_codes(str)
  -- "\27" = \x1b (ESC)
  -- We look for the pattern: ESC [ ? (digits/semicolons) (letter)
  -- Example: ^[[?25l or ^[[2K or ^[[1G
  return str:gsub("\27%[%??[%d;]*[A-Za-z]", "")
end

function M.search(query, deepseek_cmd)
  if not query or query == "" then
    print("DeepSeek requires a query argument.")
    return
  end

  -- Build the command line and run it via `system`
  local cmd = string.format('%s "%s"', deepseek_cmd, query)
  local output = vim.fn.system(cmd)

  -- If Ollama/DeepSeek returned an error, print the stripped output
  if vim.v.shell_error ~= 0 then
    print("DeepSeek command failed:")
    print(strip_ansi_codes(output))
    return
  end

  -- Otherwise, strip ANSI codes before printing the final text
  local cleaned_output = strip_ansi_codes(output)
  print(cleaned_output)
end

return M
