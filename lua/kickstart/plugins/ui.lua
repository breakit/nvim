-- UI and core UX plugins: indent, gitsigns, which-key, colorscheme, todo, mini

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
local gitsigns = require 'gitsigns'
gitsigns.setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal { ']c', bang = true } else gitsigns.nav_hunk 'next' end
    end, 'Jump to next git [c]hange')
    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal { '[c', bang = true } else gitsigns.nav_hunk 'prev' end
    end, 'Jump to previous git [c]hange')

    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'git [s]tage hunk')
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'git [r]eset hunk')
    map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
    map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
    map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, 'git preview hunk [i]nline')
    map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, 'git [b]lame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
    map('n', '<leader>hD', function() gitsigns.diffthis '~' end, 'git [D]iff against last commit')
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git show [b]lame line')
    map('n', '<leader>tw', gitsigns.toggle_word_diff, '[T]oggle git intra-line [w]ord diff')
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'text object [i]nside [h]unk')
  end,
}

vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

vim.pack.add { gh 'folke/tokyonight.nvim' }
require('tokyonight').setup {
  styles = { comments = { italic = false } },
}
vim.cmd.colorscheme 'tokyonight-night'

vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- mini.nvim: only the kickstart modules (ai, surround, statusline, icons)
vim.pack.add { gh 'nvim-mini/mini.nvim' }
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
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end
