-- Use 4 spaces for a tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- No swap files
vim.opt.swapfile = false

-- Move Selected Text Up/Down in Visual Mode
-- Pressing J/K moves the highlighted block
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For multi-key mappings
vim.opt.timeoutlen = 200

-- Disable Q originally goes to Ex mode
vim.keymap.set('n', 'Q', '<nop>')

-- ripgrep
vim.opt.grepprg = 'rg --vimgrep --no-heading'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Quits on pressing "jkl;"
vim.keymap.set('n', 'jkl;', ':quit<CR>', { noremap = true, silent = true })

-- Editor UI / usability
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true

-- Clear search highlight on <Esc>
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Easier escape from terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

-- Yank filename to clipboard
vim.keymap.set('n', '<leader>yf', function()
  vim.fn.setreg('+', vim.fn.expand '%:p')
end, { desc = 'Yank file path' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install 'lazy.nvim' if not present, then prepend to runtimepath
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeFocus' }, -- Lazy-load on command
    config = function()
      -- Optional: Configure undotree settings here
      vim.g.undotree_SetFocusWhenToggle = 1 -- Automatically focus the undotree window when toggled
      vim.g.undotree_ShortIndicators = 1 -- Use shorter indicators for branches
      vim.g.undotree_WindowLayout = 2 -- Layout: right vs left vs bottom
      vim.g.undotree_SplitWidth = 30
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious' },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Fuzzy Finder (Telescope)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- If you have a Nerd Font installed, you might also want:
      -- { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          path_display = { 'smart' },
          mappings = {
            i = { ['<C-d>'] = require('telescope.actions').delete_buffer },
            n = { ['<C-d>'] = require('telescope.actions').delete_buffer },
          },
        },
      }
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags)
      vim.keymap.set('n', '<leader>sk', builtin.keymaps)
      vim.keymap.set('n', '<leader>sf', builtin.find_files)
      vim.keymap.set('n', '<leader>ss', builtin.builtin)
      vim.keymap.set('n', '<leader>sw', builtin.grep_string)
      vim.keymap.set('n', '<leader>sg', builtin.live_grep)
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
      vim.keymap.set('n', '<leader>sr', builtin.resume)
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles)
      vim.keymap.set('n', '<leader><leader>', builtin.buffers)

      -- Fuzzy search in current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end)

      -- Live grep in open files
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end)

      -- Search Neovim config
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end)
    end,
  },

  -- LSP CONFIG
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
          map('gr', require('telescope.builtin').lsp_references, 'Goto References')
          map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        -- The enabled function checks a buffer-local variable.
        enabled = function()
          -- If vim.b.disable_formatting is true, then disable formatting.
          return not vim.b.disable_formatting
        end,
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'ruff' },
      },
    },
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  -- Colorscheme
  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'tokyonight-night'
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- mini.nvim modules
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- TREESITTER
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- NEW: Icons + oil.nvim
  {
    -- This is the standalone mini.icons plugin
    'echasnovski/mini.icons',
    version = '*',
    opts = {
      -- If you want to select a specific icon set, configure it here.
      -- e.g. use = { default = 'devicons' }
    },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      columns = { 'icon' },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      delete_to_trash = false,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false,
      },
      constrain_cursor = 'editable',
      watch_for_changes = false,
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['<leader>o'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
      use_default_keymaps = true,
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _)
          return name:match '^%.' ~= nil
        end,
        is_always_hidden = function(_, _)
          return false
        end,
        natural_order = 'fast',
        case_insensitive = false,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = 'rounded',
        win_options = { winblend = 0 },
        preview_split = 'auto',
        override = function(conf)
          return conf
        end,
      },
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch',
        disable_preview = function(_)
          return false
        end,
        win_options = {},
      },
      confirmation = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        win_options = { winblend = 0 },
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        minimized_border = 'none',
        win_options = { winblend = 0 },
      },
      ssh = {
        border = 'rounded',
      },
      keymaps_help = {
        border = 'rounded',
      },
    },
    dependencies = {
      {
        'echasnovski/mini.icons',
        version = '*',
        opts = {},
      },
      -- OR if you prefer nvim-web-devicons:
      -- "nvim-tree/nvim-web-devicons",
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Simple Python runner
vim.api.nvim_create_user_command('RunPython', function()
  require('run_python_file').run_python_file()
end, {})
require 'run_python_file'
vim.api.nvim_set_keymap('n', '<leader>p', ':RunPython<CR>', { noremap = true, silent = true })

-- Git blame on current line
vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>')

-- Quick line navigation
vim.keymap.set('n', '<C-k>', '<C-u>')
vim.keymap.set('n', '<C-j>', '<C-d>')
vim.keymap.set('v', '<C-k>', '<C-u>')
vim.keymap.set('v', '<C-j>', '<C-d>')
vim.keymap.set('n', '<C-h>', '^')
vim.keymap.set('n', '<C-l>', '$')

vim.keymap.set('n', '<leader>o', function()
  require('oil').open_float()
end, { desc = 'Open floating Oil explorer' })

-- Quickfix Navigation
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>zz')

-- Telescope Quickfix Picker
vim.api.nvim_set_keymap('n', '<leader>fl', ':Telescope quickfix<CR>', { noremap = true, silent = true })

vim.cmd.colorscheme 'catppuccin-frappe'

-- Keybindings for undotree.nvim
vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })

-- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath 'cache' .. '/undo'

-- Ensure the undo directory exists
vim.fn.mkdir(vim.fn.stdpath 'cache' .. '/undo', 'p')

vim.cmd [[
  highlight UndotreeCurrentLine guibg=#3c3836 guifg=#fb4934
  highlight UndotreeDiffAdd guifg=#b8bb26
  highlight UndotreeDiffChange guifg=#fabd2f
  highlight UndotreeDiffDelete guifg=#cc241d
]]

-- Toggle Relative Numbers
local function toggle_relative_numbers()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

-- Key mapping for toggling relative numbers only
vim.keymap.set('n', '<leader>tr', toggle_relative_numbers, { desc = 'Toggle Relative Numbers' })
