-- bootstrap plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--
-- Plugins
--
require("lazy").setup({
  -- Set color scheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
	    require("gruvbox").setup({
		    terminal_colors = true,
		    contrast = "hard",
	    })
	    vim.cmd([[colorscheme gruvbox]])
    end,
  },

  -- Configure status bar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("lualine").setup({
        options = { theme = 'gruvbox' },
      })
    end,
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          local function down_node()
            local node = api.tree.get_node_under_cursor()
            return api.tree.change_root_to_node(node)
	  end

          api.config.mappings.default_on_attach(bufnr)
         
          vim.keymap.set('n', '<C-b>', api.tree.toggle, opts('Toggle file explorer'))
          vim.keymap.set('n', '<C-u>', api.tree.change_root_to_parent, opts('Move root directory up'))
          vim.keymap.set('n', '<C-d>', down_node, opts('Change root directory to node under cursor'))
          vim.keymap.set('n', '<C-[>', api.tree.collapse_all, opts('Collapse tree')) 
  	end
      })
    end,
  },

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    config = function() 
      lsp = require("lspconfig")

      -- Install with pip install ruff or brew install ruff
      lsp.ruff.setup{
        init_options = {
          settings = {
            -- extra CLI arguments for ruff go here
            args = {}
          }
        }
      }
      -- Install with npm install -g @ansible/ansible-language-server
      lsp.ansiblels.setup{
        filetypes = { "yaml", "yml" },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = "ansible-lint"
          }
        }
      }
      -- Install with npm i -g bash-language-server
      lsp.bashls.setup{}
      -- Install with cargo install gitlab-ci-ls
      lsp.gitlab_ci_ls.setup{}
      -- Install with npm i -g vscode-langservers-extracted
      lsp.jsonls.setup{}
    end,
  },

  -- github copilot
  {
    "github/copilot.vim"
  }
})

--
-- Basic configuration
--

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.opt.number = true        -- Show line numbers
vim.opt.showmatch = true     -- Highlight matching parenthesis
vim.opt.splitright = true    -- Split windows right to the current windows
vim.opt.splitbelow = true    -- Split windows below to the current windows
vim.opt.autowrite = true     -- Automatically save before :next, :make etc.
vim.opt.autochdir = true     -- Change CWD when I open a file

vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'  -- Copy/paste to system clipboard
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case 
vim.opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

vim.opt.undofile = true

-- Indent settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.wrap = true

-- Key bindings

-- File tree
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>') 
