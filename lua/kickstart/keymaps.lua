-- Keymaps and basic autocommands

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode with jk' })
vim.keymap.set('v', 'jk', '<Esc>', { desc = 'Exit visual mode with jk' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', ']t', '<cmd>tabnext<CR>', { silent = true, desc = 'Next Tab' })
vim.keymap.set('n', '[t', '<cmd>tabprev<CR>', { silent = true, desc = 'Previous Tab' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Quickfix window toggle (moved here from <leader>q)
vim.keymap.set('n', '<leader>tq', function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then qf_exists = true end
  end
  if qf_exists then vim.cmd 'cclose' else vim.cmd 'copen' end
end, { desc = '[T]oggle [Q]uickfix Window' })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next Quickfix Item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { silent = true, desc = 'Previous Quickfix Item' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
