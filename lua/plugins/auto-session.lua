return {
  'rmagatti/auto-session',
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    { '<leader>ws', '<cmd>SessionSave<CR>', desc = 'Save session' },
    { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
  },
  opts = {
    log_level = 'info',
    auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
    auto_session_enabled = true,
    auto_session_use_git_branch = false,
  },
}