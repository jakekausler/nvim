-- Global Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.copilot_no_tab_map = true

-- Load configuration
require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.utils')

-- Load all plugins
require('plugins')