-- ABL (Progress OpenEdge) filetypes, indentation, and language server.
-- The language server takes the indent width from the formatting request, not
-- from abl.toml, so these buffer options decide how <leader>f actually indents.
-- Keep them in step with indent_size = 2 / use_tabs = false in the project config.

vim.filetype.add {
  extension = {
    p = 'abl',
    w = 'abl',
    cls = 'abl',
    i = 'abl',
    df = 'df',
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'abl',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 8
  end,
})

-- Not in Mason, so it is configured by hand. Formatting goes through conform (lsp only).
vim.lsp.config('abl', {
  cmd = { '/home/yk/.cargo/bin/abl-language-server' },
  filetypes = { 'abl' },
  root_markers = { 'abl.toml', '.git' },
  settings = { formatting = { enabled = true } },
})
vim.lsp.enable 'abl'
