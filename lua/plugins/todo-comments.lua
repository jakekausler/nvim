return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  config = function(_, opts)
    require('todo-comments').setup(opts)
    
    -- TODO Comment navigation keymaps
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next todo comment' })
    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous todo comment' })

    -- Add TODOs to quickfix list
    vim.keymap.set('n', '<leader>qt', function()
      vim.cmd 'TodoQuickFix'
    end, { desc = '[Q]uickfix [T]ODOs' })

    -- Search for TODOs with Telescope
    vim.keymap.set('n', '<leader>st', function()
      vim.cmd 'TodoTelescope'
    end, { desc = '[S]earch [T]ODOs' })
  end,
}