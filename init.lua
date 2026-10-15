-- Based on kickstart.nvim (vim.pack). Layout:
--   lua/kickstart/          core options, keymaps, and base plugin setup
--   lua/custom/plugins/     personal plugins, loaded last

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'kickstart.options'
require 'kickstart.keymaps'
require 'kickstart.pack'
require 'kickstart.plugins.ui'
require 'kickstart.plugins.search'
-- completion before lsp so blink capabilities are available to servers
require 'kickstart.plugins.completion'
require 'kickstart.plugins.lsp'
require 'kickstart.plugins.conform'
require 'kickstart.plugins.treesitter'

require 'custom.plugins'

-- vim: ts=2 sts=2 sw=2 et
