-- ╭──────────────────────────╮
-- │        Hard Mode         │
-- ╰──────────────────────────╯
local M = {}

local hardmode_keys = {
  '<Up>',
  '<Down>',
  '<Left>',
  '<Right>',
  '<PageUp>',
  '<PageDown>',
  '<Home>',
  '<End>',
}

-- Function to toggle hard mode
local hardmode_enabled = false

function M.toggle_hardmode()
  hardmode_enabled = not hardmode_enabled
  for _, key in ipairs(hardmode_keys) do
    if hardmode_enabled then
      vim.keymap.set({ 'n', 'i', 'v', 'c' }, key, function()
        vim.notify('Using hardmode, find the alternative', vim.log.levels.WARN)
      end, { noremap = true, silent = true })
    else
      vim.keymap.del({ 'n', 'i', 'v', 'c' }, key)
    end
  end
  if hardmode_enabled then
    vim.notify('Hard mode enabled', vim.log.levels.INFO)
  else
    vim.notify('Hard mode disabled', vim.log.levels.INFO)
  end
end

-- Set up the keymap for hard mode toggle
vim.keymap.set('n', '<leader>hm', M.toggle_hardmode, { noremap = true, silent = true })

return M