-- Kulala HTTP client

vim.pack.add { 'https://github.com/mistweaverco/kulala.nvim' }

require('kulala').setup {}

vim.keymap.set('n', '<leader>R', function() require('kulala').run() end, { desc = 'HTTP Client: Run request under cursor' })
vim.keymap.set('n', '<leader>[', function() pcall(require('kulala').jump_prev) end, { desc = 'HTTP Client: Jump to prev request' })
vim.keymap.set('n', '<leader>]', function() pcall(require('kulala').jump_next) end, { desc = 'HTTP Client: Jump to next request' })
vim.keymap.set('n', '<leader>I', function() require('kulala').toggle_view() end, { desc = 'HTTP Client: Toggle headers/body view' })
