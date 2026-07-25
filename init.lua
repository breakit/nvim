vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'core.options'
require 'core.keymaps'
require 'core.lsp'
require 'core.commands'
require 'plugins'
require 'custom.plugins'
