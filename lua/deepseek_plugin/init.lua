local M = {}

M.config = {
  deepseek_cmd = "ollama run deepseek-r1:8b",
}

function M.setup(opts)
  opts = opts or {}
  if opts.deepseek_cmd then
    M.config.deepseek_cmd = opts.deepseek_cmd
  end

  vim.api.nvim_create_user_command(
    "DeepseekSearch",
    function(cmd_opts)
      require("deepseek_plugin.commands").search(cmd_opts.args, M.config.deepseek_cmd)
    end,
    { nargs = 1, complete = "file" }
  )
end

return M
