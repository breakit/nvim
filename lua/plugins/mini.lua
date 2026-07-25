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
  window = { delay = 50 },
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

require('mini.notify').setup {}

vim.keymap.set('n', '<leader>bd', function()
  require('mini.bufremove').delete(0, false)
end, { desc = 'Close current tab/buffer safely' })

require('mini.extra').setup {}
