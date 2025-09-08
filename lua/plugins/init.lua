-- ╭──────────────────────────╮
-- │    Plugin Manager Setup  │
-- ╰──────────────────────────╯

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Function to get all plugin files in the plugins directory
local function get_plugin_imports()
  local imports = {}
  local plugin_dir = vim.fn.stdpath 'config' .. '/lua/plugins'

  -- Get all .lua files in the plugins directory
  local files = vim.fn.glob(plugin_dir .. '/*.lua', false, true)

  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ':t:r') -- Get filename without extension
    -- Skip init.lua (this file)
    if filename ~= 'init' then
      table.insert(imports, { import = 'plugins.' .. filename })
    end
  end

  return imports
end

-- Setup lazy.nvim
local plugin_imports = get_plugin_imports()

require('lazy').setup(plugin_imports)

