return {
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
}