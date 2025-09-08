return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    enable = true,
    max_lines = 0, -- How many lines the context window can be (0 = no limit)
    trim_scope = 'outer', -- Which scope to remove if the context is too big
    min_window_height = 0, -- Don't show if the window is smaller than this
    mode = 'cursor', -- "cursor" = top context at cursor, "topline" = top visible line
    separator = '.', -- Separator between context and current line
  },
}