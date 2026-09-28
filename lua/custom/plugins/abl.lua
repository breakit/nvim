vim.filetype.add {
  extension = {
    p = 'abl',
    w = 'abl',
    cls = 'abl',
    i = 'abl',
    df = 'df',
  },
}

-- The language server takes the indent width from the formatting request, not
-- from abl.toml, so these buffer options decide how <leader>f actually indents.
-- Keep them in step with indent_size = 2 / use_tabs = false in the project
-- config: 2 spaces, no tabs.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'abl',
  callback = function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 8
  end,
})
