-- ╭───────-──────────────────╮
-- │      Global Settings     │
-- ╰──────────────────────────╯
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Do not use <Tab> for Copilot
vim.g.copilot_no_tab_map = true

-- Load configuration modules
require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.utils')

-- ╭──────────────────────────╮
-- │     General Plugins      │
-- ╰──────────────────────────╯
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, lhs, rhs, desc, opts)
          opts = opts or {}
          if desc then
            opts.desc = desc
          end
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', 'g]c', function()
          if vim.wo.diff then
            vim.cmd.normal { 'g]c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Next [C]hange')

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Previous [C]hange')

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, '[H]unk [S]tage')
        map('n', '<leader>hr', gitsigns.reset_hunk, '[H]unk [R]eset')

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[H]unk [S]tage')

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, '[H]unk [R]eset')

        map('n', '<leader>hS', gitsigns.stage_buffer, '[H]unk [S]tage Buffer')
        map('n', '<leader>hR', gitsigns.reset_buffer, '[H]unk [R]eset Buffer')

        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, '[H]unk [B]lame Line')

        map('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end, '[H]unk [Q]uickfix All')
        map('n', '<leader>hq', gitsigns.setqflist, '[H]unk [Q]uickfix')

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle [B]lame Line')
        map('n', '<leader>tw', gitsigns.toggle_word_diff, '[T]oggle [W]ord Diff')

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, '[I]nside [H]unk')
      end,
    },
  },
  { -- Allows selecting multiple incremental text
    'mg979/vim-visual-multi',
    branch = 'master',
    event = 'VeryLazy',
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-y>'] = 'select_default',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          undo = {},
        },
      }

      -- Telescope Extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'

      -- helper to wrap a picker and insert the word under cursor
      local function with_cword(picker)
        return function()
          picker { default_text = vim.fn.expand '<cword>' }
        end
      end

      -- Search with no default text
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Search with cword default text
      vim.keymap.set('n', '<leader>Sh', with_cword(builtin.help_tags), { desc = '[S]earch [H]elp with cword' })
      vim.keymap.set('n', '<leader>Sk', with_cword(builtin.keymaps), { desc = '[S]earch [K]eymaps with cword' })
      vim.keymap.set('n', '<leader>Sf', with_cword(builtin.find_files), { desc = '[S]earch [F]iles with cword' })
      vim.keymap.set('n', '<leader>Ss', with_cword(builtin.builtin), { desc = '[S]earch [S]elect Telescope with cword' })
      vim.keymap.set('n', '<leader>Sg', with_cword(builtin.live_grep), { desc = '[S]earch by [G]rep with cword' })
      vim.keymap.set('n', '<leader>Sd', with_cword(builtin.diagnostics), { desc = '[S]earch [D]iagnostics with cword' })
      vim.keymap.set('n', '<leader>Sr', with_cword(builtin.resume), { desc = '[S]earch [R]esume with cword' })
      vim.keymap.set('n', '<leader>S.', with_cword(builtin.oldfiles), { desc = '[S]earch Recent Files with cword' })
      vim.keymap.set('n', '<leader>?', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
          default_text = vim.fn.expand '<cword>',
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>S/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
          default_text = vim.fn.expand '<cword>',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>Sn', function()
        builtin.find_files {
          cwd = vim.fn.stdpath 'config',
          default_text = vim.fn.expand '<cword>',
        }
      end, { desc = '[S]earch [N]eovim files' })

      -- Search for buffers
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Show undo tree
      vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = '[U]ndo Tree' })
    end,
  },
  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 40 }
            local diff = statusline.section_diff { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local lsp = statusline.section_lsp { trunc_width = 75 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location { trunc_width = 75 }
            local search = statusline.section_searchcount { trunc_width = 75 }

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, '%2l:%-2v' } },
            }
          end,
          inactive = function()
            return '  %f'
          end,
        },
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end
    end,
  },
  { -- Allow treesitter to work with text objects
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  { -- Show current context at top of screen while scrolling
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 0, -- How many lines the context window can be (0 = no limit)
      trim_scope = 'outer', -- Which scope to remove if the context is too big
      min_window_height = 0, -- Don't show if the window is smaller than this
      mode = 'cursor', -- "cursor" = top context at cursor, "topline" = top visible line
      separator = '.', -- Separator between context and current line
    },
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn', -- Start selection
          node_incremental = 'grn', -- Increment to next node
          node_decremental = 'grm', -- Decrement to previous node
          scope_incremental = 'grc', -- Increment to next scope (function, class, etc.)
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Jump forward automatically to textobj
          keymaps = {
            ['af'] = '@function.outer', -- Select around function
            ['if'] = '@function.inner', -- Select inside function
            ['ac'] = '@class.outer', -- Around class
            ['ic'] = '@class.inner', -- Inside class
            ['aa'] = '@parameter.outer', -- Around argument
            ['ia'] = '@parameter.inner', -- Inside argument
            ['al'] = '@loop.outer', -- Around loop
            ['il'] = '@loop.inner', -- Inside loop
            ['acond'] = '@conditional.outer', -- Around if/else
            ['icond'] = '@conditional.inner', -- Inside if/else
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Set jumps in jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
  },
  { -- File Explorer
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      auto_clean_after_session_restore = true,
    },
  },
  { -- Saves and restores your NeoVim sessions
    'rmagatti/auto-session',
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
      { '<leader>ws', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },
    opts = {
      log_level = 'info',
      auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
      auto_session_enabled = true,
      auto_session_use_git_branch = false,
    },
  },
  { -- Add indentation guides
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'help',
          'lazy',
          'mason',
          'neo-tree',
          'notify',
          'toggleterm',
          'Trouble',
        },
      },
    },
  },
  { -- Github Copilot
    'github/copilot.vim',
  },
  -- ╭──────────────────────────╮
  -- │       LSP Plugins        │
  -- ╰──────────────────────────╯
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Easily define mappings specific for LSP related items.
          -- It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        eslint = {
          settings = {
            packageManager = 'yarn',
          },
          ---@diagnostic disable-next-line: unused-local
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },
        tsserver = {},
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = {
        'pyright',
        'lua-language-server',
        'eslint-lsp',
        'stylua',
        'typescript-language-server',
        'rust-analyzer',
      }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        rust = { 'rustfmt' },
        ['*'] = { 'trim_whitespace' },
      },
    },
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        preset = 'default',
        ['<C-k>'] = {},
        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          path = {
            opts = {
              show_hidden_files_by_default = true,
            },
          },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
  -- ╭──────────────────────────╮
  -- │   Color Scheme Plugins   │
  -- ╰──────────────────────────╯
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('gruvbox').setup {
  --       terminal_colors = true,
  --     }
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- },
  {
    'Koalhack/darcubox-nvim',
    config = function()
      vim.cmd 'colorscheme darcubox'
    end,
  },
  -- Import other plugins from `./lua/custom/plugins/*.lua`
  { import = 'custom.plugins' },
}

-- ╭──────────────────────────╮
-- │         Keymaps          │
-- ╰──────────────────────────╯
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open [Q]uickfix [D]iagnostic list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Copilot
vim.keymap.set('i', '<C-c>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

-- Inline Movement
local expr = { silent = true, expr = true, remap = false }
vim.keymap.set('n', '<Up>', "(v:count == 0 ? 'gk' : 'k')", expr)
vim.keymap.set('n', '<Down>', "(v:count == 0 ? 'gj' : 'j')", expr)
vim.keymap.set('n', 'j', "(v:count == 0 ? 'gj' : 'j')", expr)
vim.keymap.set('n', 'k', "(v:count == 0 ? 'gk' : 'k')", expr)

-- Toggle NeoTree or focus it if already open
vim.keymap.set('n', '<leader>B', function()
  local current_ft = vim.bo.filetype

  -- If currently in Neo-tree, close it
  if current_ft == 'neo-tree' then
    vim.cmd 'Neotree close'
  else
    -- Otherwise, focus an open tree if it exists, or open it
    local found_tree = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
      if ft == 'neo-tree' then
        vim.api.nvim_set_current_win(win)
        found_tree = true
        break
      end
    end

    if not found_tree then
      vim.cmd 'Neotree focus'
    end
  end
end, { desc = 'Smart focus/close NeoTree' })

-- Smarter three-way toggle for line numbers in Neovim
-- Cycle: Absolute → Relative → Off → Absolute ...
-- Detects current mode so it always continues naturally
-- Displays the new mode in a :echo message
vim.keymap.set('n', '<leader>tn', function()
  local num = vim.o.number -- true if absolute numbers are on
  local rnum = vim.o.relativenumber -- true if relative numbers are on

  if not num and not rnum then
    -- Off → Absolute
    vim.o.number = true
    vim.o.relativenumber = false
    vim.notify('Line numbers: Absolute', vim.log.levels.INFO)
  elseif num and not rnum then
    -- Absolute → Relative
    vim.o.number = true
    vim.o.relativenumber = true
    vim.notify('Line numbers: Relative', vim.log.levels.INFO)
  elseif num and rnum then
    -- Relative → Off
    vim.o.number = false
    vim.o.relativenumber = false
    vim.notify('Line numbers: Off', vim.log.levels.INFO)
  else
    -- Weird config → reset to Absolute
    vim.o.number = true
    vim.o.relativenumber = false
    vim.notify('Line numbers: Absolute (reset)', vim.log.levels.WARN)
  end
end, { desc = '[T]oggle line [N]umbers (cycle, state-aware)' })

-- Yank to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })

-- Terminal Safe Command/insert navigation
local modes = { 'i', 'c' } -- Insert and Command-line modes
vim.keymap.set(modes, '<C-h>', '<Left>', { noremap = true })
vim.keymap.set(modes, '<C-l>', '<Right>', { noremap = true })
vim.keymap.set(modes, '<C-j>', '<Down>', { noremap = true })
vim.keymap.set(modes, '<C-k>', '<Up>', { noremap = true })
-- vim.keymap.set(modes, '<C-w>', '<C-Right>', { noremap = true }) -- Word forward
-- vim.keymap.set(modes, '<C-b>', '<C-Left>', { noremap = true }) -- Word backward
-- vim.keymap.set(modes, '<C-e>', '<End>', { noremap = true }) -- End of line
-- vim.keymap.set(modes, '<C-q>', '<Home>', { noremap = true }) -- Start of line
-- vim.keymap.set(modes, '<C-u>', '<PageUp>', { noremap = true }) -- Page up
-- vim.keymap.set(modes, '<C-d>', '<PageDown>', { noremap = true }) -- Page down

-- Delete in insert/command mode
vim.keymap.set(modes, '<A-h>', '<Backspace>', { noremap = true }) -- Backspace
vim.keymap.set(modes, '<A-l>', '<Delete>', { noremap = true }) -- Delete
-- vim.keymap.set('i', '<A-j>', '<C-o>jdd', { noremap = true }) -- Delete the line below
-- vim.keymap.set('i', '<A-k>', '<C-o>kdd', { noremap = true }) -- Delete the line above
-- vim.keymap.set('i', '<A-q>', '<C-u>', { noremap = true }) -- Delete to start of line
-- vim.keymap.set('i', '<A-e>', '<C-o>D', { noremap = true }) -- Delete to start of line

-- Increment Number Overrides
vim.keymap.set('n', '<leader>z', '<C-a>', { noremap = true }) -- Increment number
vim.keymap.set('v', '<leader>z', '<C-a>', { noremap = true }) -- Increment number
vim.keymap.set('v', '<leader>gz', 'g<C-a>', { noremap = true }) -- Increment number
-- Decrement Number Overrides
vim.keymap.set('n', '<leader>x', '<C-x>', { noremap = true }) -- Decrement number
vim.keymap.set('v', '<leader>x', '<C-x>', { noremap = true }) -- Decrement number
vim.keymap.set('v', '<leader>gx', 'g<C-x>', { noremap = true }) -- Decrement number

-- Indent in insert mode
-- vim.keymap.set('i', '<A-d>', '<C-d>', { noremap = true }) -- De-indent
-- vim.keymap.set('i', '<A-t>', '<C-t>', { noremap = true }) -- Indent

-- Easier retrigger of last macro
vim.keymap.set('n', 'Q', '@@', { desc = 'Replay last macro' })

-- Buffer Navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bf', '<cmd>bf<CR>', { desc = '[B]uffer [F]irst' })
vim.keymap.set('n', '<leader>bl', '<cmd>bl<CR>', { desc = '[B]uffer [L]ast' })
vim.keymap.set('n', '<leader>bs', '<cmd>ls<CR>', { desc = 'List [B]uffer[s]' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bg', function()
  local count = vim.v.count
  if count == 0 then
    vim.notify('No buffer number provided', vim.log.levels.WARN)
  else
    vim.cmd('buffer ' .. count)
  end
end, { desc = '[B]uffer [G]oto <count>' })
vim.keymap.set('n', '<leader>b#', '<cmd>buffer #<CR>', { desc = '[B]uffer [#] Previous' })

-- Quickfix Navigation
vim.keymap.set('n', '<leader>qs', '<cmd>copen<CR>', { desc = '[Q]uick[f]ix Open' })
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', { desc = '[Q]uickfix [N]ext' })
vim.keymap.set('n', '<leader>qp', '<cmd>cprev<CR>', { desc = '[Q]uickfix [P]revious' })
vim.keymap.set('n', '<leader>qf', '<cmd>cfirst<CR>', { desc = '[Q]uickfix [F]irst' })
vim.keymap.set('n', '<leader>ql', '<cmd>clast<CR>', { desc = '[Q]uickfix [L]ast' })
vim.keymap.set('n', '<leader>qg', function()
  local count = vim.v.count
  if count == 0 then
    vim.notify('No quickfix number provided', vim.log.levels.WARN)
  else
    vim.cmd('cc ' .. count)
  end
end, { desc = '[Q]uickfix [G]oto <count>' })

-- Remove Highlights on escape
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Remove highlights' })

-- Smart Command Line History (when not in wildmenu)
vim.keymap.set('c', '<C-n>', function()
  return vim.fn.wildmenumode() == 1 and '<C-n>' or '<Down>'
end, { expr = true, noremap = true })
vim.keymap.set('c', '<C-p>', function()
  return vim.fn.wildmenumode() == 1 and '<C-p>' or '<Up>'
end, { expr = true, noremap = true })

-- Quick Move Line
vim.keymap.set('n', '[e', function()
  vim.cmd('move -1-' .. vim.v.count1)
end, { silent = true })
vim.keymap.set('n', ']e', function()
  vim.cmd('move +' .. vim.v.count1)
end, { silent = true })

-- Don't lose selection when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and keep selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and keep selection' })

-- Show errors and warnings in a floating window
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, source = 'if_many' })
  end,
})

-- TODO Comment Jumping
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  reqtire('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Add TODOs to quickfix list
vim.keymap.set('n', '<leader>qt', function()
  vim.cmd 'TodoQuickFix'
end, { desc = '[Q]uickfix [T]ODOs' })

-- Search for TODOs with Telescope
vim.keymap.set('n', '<leader>st', function()
  vim.cmd 'TodoTelescope'
end, { desc = '[S]earch [T]ODOs' })
