vim.pack.add { { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' } }

if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

require('mini.ai').setup {
  mappings = { around_next = 'aa', inside_next = 'ii' },
  n_lines = 500,
}

require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function() return '%2l:%-2v' end

require('mini.tabline').setup { show_icons = true }
require('mini.bufremove').setup {}
require('mini.completion').setup {}
require('mini.snippets').setup {}
require('mini.move').setup {}
require('mini.splitjoin').setup {}
require('mini.cmdline').setup {}
require('mini.trailspace').setup {}
require('mini.git').setup()
require('mini.align').setup {}

require('mini.clue').setup {
  window = { delay = 50, config = { border = 'single' } },
  clues = {
    { mode = 'n', keys = '<leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '<leader>' },
    { mode = 'i', keys = '<C-x>' },
  },
  triggers = {
    { mode = 'n', keys = '<leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '<leader>' },
    { mode = 'i', keys = '<C-x>' },
  },
}

require('mini.pairs').setup {}
require('mini.indentscope').setup {}
require('mini.diff').setup {}

require('mini.notify').setup {
  window = { config = { border = 'single' } },
}

vim.keymap.set('n', '<leader>bd', function()
  require('mini.bufremove').delete(0, false)
end, { desc = 'Close current tab/buffer safely' })

local function link_mini_hl()
  local gray = vim.api.nvim_get_hl(0, { name = 'Comment' }).fg
  vim.api.nvim_set_hl(0, 'MiniClueBorder',     { fg = gray, bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniClueDescGroup',  { link = 'Title' })
  vim.api.nvim_set_hl(0, 'MiniClueDescSingle', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'MiniClueNextKey',    { link = 'Special' })
  vim.api.nvim_set_hl(0, 'MiniClueSeparator',  { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'MiniNotifyBorder',   { fg = gray, bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniNotifyNormal',   { link = 'NormalFloat' })
  vim.api.nvim_set_hl(0, 'MiniNotifyTitle',    { link = 'Title' })
end
link_mini_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('mini-tokyonight', { clear = true }),
  callback = link_mini_hl,
})
