-- ╭───────-──────────────────╮
-- │      Global Settings     │
-- ╰──────────────────────────╯
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Do not use <Tab> for Copilot
vim.g.copilot_no_tab_map = true

-- Load configuration modules
require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.utils')

-- Load plugins
require('plugins')

-- All plugin configurations now handled in lua/plugins/

