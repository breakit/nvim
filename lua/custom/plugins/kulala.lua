vim.pack.add({
	'https://github.com/mistweaverco/kulala.nvim'
})

-- 1. Run initialization setup
require('kulala').setup({
  -- You can add optional configurations here later (like custom icon markers)
})

-- 2. Define API testing keymaps
-- Run the specific HTTP request your cursor is currently on
vim.keymap.set('n', '<leader>R', function() 
  require('kulala').run() 
end, { desc = "HTTP Client: Run request under cursor" })

-- Cycle forward/backward through your API call history logs
vim.keymap.set('n', '<leader>[', function() pcall(require('kulala').jump_prev) end, { desc = "HTTP Client: Jump to prev request" })
vim.keymap.set('n', '<leader>]', function() pcall(require('kulala').jump_next) end, { desc = "HTTP Client: Jump to next request" })

-- Toggle between the raw response headers and body text
vim.keymap.set('n', '<leader>I', function() 
  require('kulala').toggle_view() 
end, { desc = "HTTP Client: Toggle headers/body view" })

