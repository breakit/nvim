-- Snippets (LuaSnip) and completion (blink.cmp)

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  snippets = { preset = 'luasnip' },
  -- prefer_rust_with_warning uses the prebuilt fuzzy matcher, falling back to lua
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
