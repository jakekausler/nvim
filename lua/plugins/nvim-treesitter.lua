return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn', -- Start selection
        node_incremental = 'grn', -- Increment to next node
        node_decremental = 'grm', -- Decrement to previous node
        scope_incremental = 'grc', -- Increment to next scope (function, class, etc.)
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Jump forward automatically to textobj
        keymaps = {
          ['af'] = '@function.outer', -- Select around function
          ['if'] = '@function.inner', -- Select inside function
          ['ac'] = '@class.outer', -- Around class
          ['ic'] = '@class.inner', -- Inside class
          ['aa'] = '@parameter.outer', -- Around argument
          ['ia'] = '@parameter.inner', -- Inside argument
          ['al'] = '@loop.outer', -- Around loop
          ['il'] = '@loop.inner', -- Inside loop
          ['acond'] = '@conditional.outer', -- Around if/else
          ['icond'] = '@conditional.inner', -- Inside if/else
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- Set jumps in jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']c'] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[c'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  },
}