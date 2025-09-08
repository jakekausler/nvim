-- ╭──────────────────────────╮
-- │         Options          │
-- ╰──────────────────────────╯
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.opt.confirm = true

-- Wildmenu
vim.opt.wildmode = { 'longest:full', 'full' }
vim.opt.wildmenu = true

-- guicursor
vim.opt.guicursor = {
  'n-v-c:block', -- Normal, Visual, Command: block cursor
  'i-ci:ver25', -- Insert and Command-insert: vertical bar cursor (25% height)
  'r-cr:hor20', -- Replace and Command-replace: horizontal underscore
  'o:hor50', -- Operator-pending: half-height horizontal line
  'a:blinkon100', -- Blink settings
}

-- Tabs and Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Splits
vim.opt.fillchars:append {
  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
  vert = '│',
  vertleft = '┤',
  vertright = '├',
  verthoriz = '┼',
}

-- Allow files to be moved to the background without saving first
vim.opt.hidden = true

-- Auto Session
vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Tree Sitter Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99

-- Don't during macro or register execution
vim.opt.lazyredraw = true

-- Diagnostics (basic config - detailed config will be in LSP)
vim.diagnostic.config {
  virtual_text = false,
  underline = true,
}