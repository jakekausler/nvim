-- Set leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load configuration
require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.utils')

-- Load all plugins
require('plugins')