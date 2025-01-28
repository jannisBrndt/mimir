local M = {}

function M.search(query, deepseek_cmd)
  if not query or query == "" then
    print("DeepSeek requires a query argument.")
    return
  end

  local cmd = string.format('%s "%s"', deepseek_cmd, query)
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("DeepSeek command failed:")
    print(output)
    return
  end

  print(output)
end

return M
