-- ~/.config/nvim/lua/plugins/markdownlint.lua
local config_path = vim.fn.stdpath("config") .. "/markdownlint-cli2.jsonc"

-- write the config file if it doesn't exist
if vim.fn.filereadable(config_path) == 0 then
  local f = io.open(config_path, "w")
  if f then
    f:write('{ "config": { "MD013": false } }')
    f:close()
  end
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        args = { "--config", config_path, "--" },
      }
      return opts
    end,
  },
}
