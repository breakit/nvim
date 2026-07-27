vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-abl-highlight', { clear = true }),
  pattern = { 'abl' },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
