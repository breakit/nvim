vim.pack.add { 'https://github.com/renerocksai/telekasten.nvim' }

require('telekasten').setup {
  home = vim.fn.expand('~/notes'),
}

vim.keymap.set('n', '<leader>zn', '<Cmd>Telekasten new_note<CR>', { desc = 'New note' })
vim.keymap.set('n', '<leader>zf', '<Cmd>Telekasten find_notes<CR>', { desc = 'Find notes' })
vim.keymap.set('n', '<leader>zg', '<Cmd>Telekasten search_notes<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>zd', '<Cmd>Telekasten goto_today<CR>', { desc = 'Go to today' })
vim.keymap.set('n', '<leader>zb', '<Cmd>Telekasten show_backlinks<CR>', { desc = 'Show backlinks' })
