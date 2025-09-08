return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '│',
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        'help',
        'lazy',
        'mason',
        'neo-tree',
        'notify',
        'toggleterm',
        'Trouble',
      },
    },
  },
}