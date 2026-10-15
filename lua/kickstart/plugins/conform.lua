-- Formatting: conform.nvim

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'stevearc/conform.nvim' }

-- Filetypes formatted on save. abl uses the language server only (indent is
-- decided by the server), everything else falls back to the LSP if no
-- conform formatter is set.
local format_on_save_fts = {
  lua = true,
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  json = true,
  jsonc = true,
  css = true,
  go = true,
  abl = true,
}

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if not format_on_save_fts[ft] then return nil end
    return {
      timeout_ms = 1000,
      lsp_format = ft == 'abl' and 'only' or 'fallback',
    }
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    css = { 'biome' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true }
end, { desc = '[F]ormat buffer' })
