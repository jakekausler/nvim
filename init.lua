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

-- ╭──────────────────────────╮
-- │    Remaining Keymaps     │
-- ╰──────────────────────────╯
-- NOTE: These keymaps are still here - need to be moved to config/keymaps.lua in Stage 4

-- ╭──────────────────────────╮
-- │         Keymaps          │
-- ╰──────────────────────────╯
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open [Q]uickfix [D]iagnostic list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Copilot
vim.keymap.set('i', '<C-c>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

-- Inline Movement
local expr = { silent = true, expr = true, remap = false }
vim.keymap.set('n', '<Up>', "(v:count == 0 ? 'gk' : 'k')", expr)
vim.keymap.set('n', '<Down>', "(v:count == 0 ? 'gj' : 'j')", expr)
vim.keymap.set('n', 'j', "(v:count == 0 ? 'gj' : 'j')", expr)
vim.keymap.set('n', 'k', "(v:count == 0 ? 'gk' : 'k')", expr)

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

-- Smarter three-way toggle for line numbers in Neovim
-- Cycle: Absolute → Relative → Off → Absolute ...
-- Detects current mode so it always continues naturally
-- Displays the new mode in a :echo message
vim.keymap.set('n', '<leader>tn', function()
  local num = vim.o.number -- true if absolute numbers are on
  local rnum = vim.o.relativenumber -- true if relative numbers are on

  if not num and not rnum then
    -- Off → Absolute
    vim.o.number = true
    vim.o.relativenumber = false
    vim.notify('Line numbers: Absolute', vim.log.levels.INFO)
  elseif num and not rnum then
    -- Absolute → Relative
    vim.o.number = true
    vim.o.relativenumber = true
    vim.notify('Line numbers: Relative', vim.log.levels.INFO)
  elseif num and rnum then
    -- Relative → Off
    vim.o.number = false
    vim.o.relativenumber = false
    vim.notify('Line numbers: Off', vim.log.levels.INFO)
  else
    -- Weird config → reset to Absolute
    vim.o.number = true
    vim.o.relativenumber = false
    vim.notify('Line numbers: Absolute (reset)', vim.log.levels.WARN)
  end
end, { desc = '[T]oggle line [N]umbers (cycle, state-aware)' })

-- Yank to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })

-- Terminal Safe Command/insert navigation
local modes = { 'i', 'c' } -- Insert and Command-line modes
vim.keymap.set(modes, '<C-h>', '<Left>', { noremap = true })
vim.keymap.set(modes, '<C-l>', '<Right>', { noremap = true })
vim.keymap.set(modes, '<C-j>', '<Down>', { noremap = true })
vim.keymap.set(modes, '<C-k>', '<Up>', { noremap = true })
-- vim.keymap.set(modes, '<C-w>', '<C-Right>', { noremap = true }) -- Word forward
-- vim.keymap.set(modes, '<C-b>', '<C-Left>', { noremap = true }) -- Word backward
-- vim.keymap.set(modes, '<C-e>', '<End>', { noremap = true }) -- End of line
-- vim.keymap.set(modes, '<C-q>', '<Home>', { noremap = true }) -- Start of line
-- vim.keymap.set(modes, '<C-u>', '<PageUp>', { noremap = true }) -- Page up
-- vim.keymap.set(modes, '<C-d>', '<PageDown>', { noremap = true }) -- Page down

-- Delete in insert/command mode
vim.keymap.set(modes, '<A-h>', '<Backspace>', { noremap = true }) -- Backspace
vim.keymap.set(modes, '<A-l>', '<Delete>', { noremap = true }) -- Delete
-- vim.keymap.set('i', '<A-j>', '<C-o>jdd', { noremap = true }) -- Delete the line below
-- vim.keymap.set('i', '<A-k>', '<C-o>kdd', { noremap = true }) -- Delete the line above
-- vim.keymap.set('i', '<A-q>', '<C-u>', { noremap = true }) -- Delete to start of line
-- vim.keymap.set('i', '<A-e>', '<C-o>D', { noremap = true }) -- Delete to start of line

-- Increment Number Overrides
vim.keymap.set('n', '<leader>z', '<C-a>', { noremap = true }) -- Increment number
vim.keymap.set('v', '<leader>z', '<C-a>', { noremap = true }) -- Increment number
vim.keymap.set('v', '<leader>gz', 'g<C-a>', { noremap = true }) -- Increment number
-- Decrement Number Overrides
vim.keymap.set('n', '<leader>x', '<C-x>', { noremap = true }) -- Decrement number
vim.keymap.set('v', '<leader>x', '<C-x>', { noremap = true }) -- Decrement number
vim.keymap.set('v', '<leader>gx', 'g<C-x>', { noremap = true }) -- Decrement number

-- Indent in insert mode
-- vim.keymap.set('i', '<A-d>', '<C-d>', { noremap = true }) -- De-indent
-- vim.keymap.set('i', '<A-t>', '<C-t>', { noremap = true }) -- Indent

-- Easier retrigger of last macro
vim.keymap.set('n', 'Q', '@@', { desc = 'Replay last macro' })

-- Buffer Navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bf', '<cmd>bf<CR>', { desc = '[B]uffer [F]irst' })
vim.keymap.set('n', '<leader>bl', '<cmd>bl<CR>', { desc = '[B]uffer [L]ast' })
vim.keymap.set('n', '<leader>bs', '<cmd>ls<CR>', { desc = 'List [B]uffer[s]' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bg', function()
  local count = vim.v.count
  if count == 0 then
    vim.notify('No buffer number provided', vim.log.levels.WARN)
  else
    vim.cmd('buffer ' .. count)
  end
end, { desc = '[B]uffer [G]oto <count>' })
vim.keymap.set('n', '<leader>b#', '<cmd>buffer #<CR>', { desc = '[B]uffer [#] Previous' })

-- Quickfix Navigation
vim.keymap.set('n', '<leader>qs', '<cmd>copen<CR>', { desc = '[Q]uick[f]ix Open' })
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', { desc = '[Q]uickfix [N]ext' })
vim.keymap.set('n', '<leader>qp', '<cmd>cprev<CR>', { desc = '[Q]uickfix [P]revious' })
vim.keymap.set('n', '<leader>qf', '<cmd>cfirst<CR>', { desc = '[Q]uickfix [F]irst' })
vim.keymap.set('n', '<leader>ql', '<cmd>clast<CR>', { desc = '[Q]uickfix [L]ast' })
vim.keymap.set('n', '<leader>qg', function()
  local count = vim.v.count
  if count == 0 then
    vim.notify('No quickfix number provided', vim.log.levels.WARN)
  else
    vim.cmd('cc ' .. count)
  end
end, { desc = '[Q]uickfix [G]oto <count>' })

-- Remove Highlights on escape
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Remove highlights' })

-- Smart Command Line History (when not in wildmenu)
vim.keymap.set('c', '<C-n>', function()
  return vim.fn.wildmenumode() == 1 and '<C-n>' or '<Down>'
end, { expr = true, noremap = true })
vim.keymap.set('c', '<C-p>', function()
  return vim.fn.wildmenumode() == 1 and '<C-p>' or '<Up>'
end, { expr = true, noremap = true })

-- Quick Move Line
vim.keymap.set('n', '[e', function()
  vim.cmd('move -1-' .. vim.v.count1)
end, { silent = true })
vim.keymap.set('n', ']e', function()
  vim.cmd('move +' .. vim.v.count1)
end, { silent = true })

-- Don't lose selection when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and keep selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and keep selection' })

-- Show errors and warnings in a floating window
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, source = 'if_many' })
  end,
})

-- TODO Comment Jumping
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  reqtire('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Add TODOs to quickfix list
vim.keymap.set('n', '<leader>qt', function()
  vim.cmd 'TodoQuickFix'
end, { desc = '[Q]uickfix [T]ODOs' })

-- Search for TODOs with Telescope
vim.keymap.set('n', '<leader>st', function()
  vim.cmd 'TodoTelescope'
end, { desc = '[S]earch [T]ODOs' })
