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

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.keymap.set('n', '<leader>q', function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then qf_exists = true end
  end
  if qf_exists then vim.cmd 'cclose' else vim.cmd 'copen' end
end, { desc = 'Toggle Quickfix Window' })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next Quickfix Item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { silent = true, desc = 'Previous Quickfix Item' })

local function p(name)
  return function(...) return require('mini.extra').pickers[name](...) end
end

vim.keymap.set('n', '<leader>sh', p 'help', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', p 'keymaps', { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', p 'files', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', p 'builtin', { desc = '[S]earch [S]elect picker' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', p 'grep_string', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', p 'grep', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', p 'diagnostic', { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', p 'resume', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', p 'visit', { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', p 'buffers', { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', p 'buffer', { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>sn', function()
  require('mini.extra').pickers.files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>s/', function()
  require('mini.extra').pickers.grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
end, { desc = '[S]earch [/] in Open Files' })
