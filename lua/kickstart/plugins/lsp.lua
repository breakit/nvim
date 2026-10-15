-- LSP: nvim-lspconfig, mason, LspAttach keymaps, and server configuration

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'j-hui/fidget.nvim',
}

require('fidget').setup {}
require('mason').setup {}
require('mason-lspconfig').setup { automatic_enable = false }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Same as kickstart: these open Telescope pickers
    local builtin = require 'telescope.builtin'

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('grr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf, group = hl_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf, group = hl_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end

    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end

    if client and client:supports_method('textDocument/inlineCompletion', event.buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
      map('<C-f>', vim.lsp.inline_completion.get, 'Trigger inline completion', 'i')
      map('<C-g>', vim.lsp.inline_completion.select, 'Next inline completion', 'i')
    end
  end,
})

-- Advertise blink.cmp capabilities to every server
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

-- Formatting is owned by conform.nvim for stylua and biome, so their LSP
-- formatting is turned off here.
local no_lsp_format = function(client)
  client.server_capabilities.documentFormattingProvider = false
end

local servers = {
  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  oxlint = {},
  biome = { on_init = no_lsp_format },
  html = {
    settings = {
      html = {
        format = { enable = false },
        embeddedLanguages = { css = true, javascript = true },
        autoClosingTags = true,
      },
    },
  },
  emmet_language_server = {},
  stylua = { on_init = no_lsp_format },
  svelte = {},
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config'
          and (vim.uv.fs_stat(path .. '/.luarc.json')
            or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
          return
        end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    settings = { Lua = { format = { enable = false } } },
  },
  tailwindcss = {},
  cssmodules_ls = {},
  templ = {
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_markers = { 'templ.toml', 'go.mod' },
  },
}

-- Mason installs these servers (and the formatters used by conform)
local ensure_installed = vim.tbl_keys(servers)
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
