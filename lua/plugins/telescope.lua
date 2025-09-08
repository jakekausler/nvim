return {
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
}