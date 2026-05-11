return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", "<leader>fE", desc = "Explorer (cwd)", remap = true },
    { "<leader>E", "<leader>fe", desc = "Explorer (root dir)", remap = true },
  },
  opts = {
    styles = {
      notification = { focusable = false },
    },
    picker = {
      sources = {
        explorer = {
          actions = {
            cd_up = function(picker)
              local parent = vim.fs.dirname(picker:cwd())
              vim.fn.chdir(parent)
              picker:set_cwd(parent)
              picker:find()
            end,
          },
          win = {
            input = {
              focusable = false,
            },
            list = {
              keys = {
                ["<c-d>"] = "cd",
                ["<c-u>"] = "cd_up",
              },
            },
          },
        },
      },
    },
  },
}
