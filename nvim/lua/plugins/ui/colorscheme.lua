return {
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    config = function()
      -- moonfly is configured via globals, which must be set before the
      -- colorscheme is applied.
      vim.g.moonflyNormalFloat = true
      vim.g.moonflyVirtualTextColor = true

      vim.cmd [[colorscheme moonfly]]
    end,
  },
}
