local gh = function(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'neovim/nvim-lspconfig' }

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')
    map('gri', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('gO', vim.lsp.buf.document_symbol, 'Document Symbols')
    map('gW', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
    map('grt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
    map('<leader>f', function() vim.lsp.buf.format { async = true } end, '[F]ormat buffer')

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

    -- Format on save for gopls
    if client and client.name == 'gopls' and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format { async = false, bufnr = event.buf }
        end,
      })
    end
  end,
})

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
  biome = {},
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
  stylua = {},
  svelte = {},
  abl = {
    cmd = { '/home/yk/.cargo/bin/abl-language-server' },
    filetypes = { 'abl' },
    root_markers = { 'abl.toml', '.git' },
    settings = { formatting = { enabled = true } },
  },
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

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
