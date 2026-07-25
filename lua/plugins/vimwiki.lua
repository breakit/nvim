vim.pack.add { 'https://github.com/vimwiki/vimwiki' }

vim.g.vimwiki_list = {
  { path = '~/notes', syntax = 'markdown', ext = '.md' },
}

vim.keymap.set('n', '<leader>wn', '<Cmd>VimwikiIndex<CR>', { desc = 'Vimwiki index' })
vim.keymap.set('n', '<leader>wd', '<Cmd>VimwikiMakeDiaryNote<CR>', { desc = 'Vimwiki diary note' })
vim.keymap.set('n', '<leader>wf', '<Cmd>VimwikiSearch<CR>', { desc = 'Vimwiki search' })
vim.keymap.set('n', '<leader>wt', '<Cmd>VimwikiToggleListItem<CR>', { desc = 'Toggle checklist item' })
