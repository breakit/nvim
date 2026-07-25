-- Toggle Quickfix window (using <leader>q)
vim.keymap.set('n', '<leader>q', function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then qf_exists = true end
  end
  if qf_exists then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end, { desc = 'Toggle Quickfix Window' })

-- Jump to NEXT quickfix item
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next Quickfix Item' })

-- Jump to PREVIOUS quickfix item
vim.keymap.set('n', '[q', ':cprev<CR>', { silent = true, desc = 'Previous Quickfix Item' })
