return {
  'github/copilot.vim',
  config = function()
    -- Copilot accept suggestion keymap
    vim.keymap.set('i', '<C-c>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
}