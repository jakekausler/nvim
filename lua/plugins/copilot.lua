return {
  'github/copilot.vim',
  config = function()
    -- Do not use <Tab> for Copilot
    vim.g.copilot_no_tab_map = true
    
    -- Copilot accept suggestion keymap
    vim.keymap.set('i', '<C-c>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
}