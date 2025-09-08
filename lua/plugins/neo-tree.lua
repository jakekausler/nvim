return {
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
  config = function(_, opts)
    require('neo-tree').setup(opts)
    
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
  end,
}