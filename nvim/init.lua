vim.g.mapleader = ","
vim.g.maplocalleader = ","

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
  -- Appearance plugins
  -- Configure status bar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("lualine").setup({
        options = { theme = 'material' },
      })
    end
  },
  -- Set color scheme
  {
    "marko-cerovac/material.nvim",
    config = function ()
      require("material").setup({
        contrast = {
          terminal = true,
          sidebars = true,
        },
        high_visibility = {
          darker = true,
        },
        lualine_style = "default",
      })
    end,
  },
  --
  
  -- Language plugins
  -- treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "python", "bash", "dockerfile", "html", "json", "yaml" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- confirm (formatter)
  {
    "stevearc/conform.nvim",
    config = function ()
      conform = require("conform")
      conform.setup({
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
          javascript = { "eslint_d" },
  	},
      })
    end
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
      -- Install with npm i -g vscode-langservers-extracted
      lsp.eslint.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    end,
  },


  -- Functionality plugins
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = false,
          custom = { '^.git$' },
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
         
          vim.keymap.set('n', '<leader>b', api.tree.toggle, opts('Toggle file explorer'))
          vim.keymap.set('n', '<leader>u', api.tree.change_root_to_parent, opts('Move root directory up'))
          vim.keymap.set('n', '<leader>d', down_node, opts('Change root directory to node under cursor'))
          vim.keymap.set('n', '<leader>[', api.tree.collapse_all, opts('Collapse tree')) 
  	end
      })
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
  -- github copilot
  --{
  --  "github/copilot.vim"
  --},
  
  -- local plugin
  {
    "shanetwinterhalter/llms.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local system_prompt = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
      local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far. You are very curt , yet helpful'
      local model = 'gpt-4o-mini'
      local api_endpoint = 'https://api.openai.com/v1/chat/completions'
      local llm = require("llms")

      local function openai_help()
        llm.invoke_llm_and_stream_into_editor({
          url = api_endpoint, 
          model = model, 
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = helpful_prompt,
          replace = false
        })
      end

      local function openai_replace()
        llm.invoke_llm_and_stream_into_editor({
          url = api_endpoint, 
          model = model,
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = system_prompt,
          replace = true
        })
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>K', openai_help, { desc = 'llms openai help' })
      vim.keymap.set({ 'n', 'v' }, '<leader>k', openai_replace, { desc = 'llms openai code' })
    end,
  },
})

--
-- Basic configuration
--

vim.cmd 'colorscheme material'
vim.g.material_style = "deep ocean"

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

vim.wo.relativenumber = true

-- Key bindings

-- File tree
vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>') 
