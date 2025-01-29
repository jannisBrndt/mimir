local M = {}

M.config = {
  deepseek_cmd = "ollama run deepseek-r1:8b",
}

function M.setup(opts)
  opts = opts or {}
  if opts.deepseek_cmd then
    M.config.deepseek_cmd = opts.deepseek_cmd
  end

  -- Existing "DeepseekSearch" command
  vim.api.nvim_create_user_command(
    "DeepseekSearch",
    function(cmd_opts)
      require("deepseek_plugin.commands").search(cmd_opts.args, M.config.deepseek_cmd)
    end,
    { nargs = 1, complete = "file" }
  )

  -- NEW: "DeepseekSearchFloat" command to open a floating terminal
  vim.api.nvim_create_user_command(
    "DeepseekSearchFloat",
    function(cmd_opts)
      require("deepseek_plugin.commands").search_in_floating_term(cmd_opts.args, M.config.deepseek_cmd)
    end,
    { nargs = 1, complete = "file" }
  )
end

return M
