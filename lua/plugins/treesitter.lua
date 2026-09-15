local function setup_hl_links(lang)
  local ok, query = pcall(vim.treesitter.query.get, lang, 'highlights')
  if not ok or not query then
    return
  end
  for _, capture in ipairs(query.captures) do
    if not vim.startswith(capture, '_') then
      local lang_group = '@' .. capture .. '.' .. lang
      local base_group = '@' .. capture
      vim.api.nvim_set_hl(0, lang_group, { link = base_group, default = true })
    end
  end
end

setup_hl_links('abl')
setup_hl_links('df')
setup_hl_links('templ')

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-custom-highlight', { clear = true }),
  pattern = { 'abl', 'df', 'templ' },
  callback = function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if not ok then
      return
    end
    local parser = vim.treesitter.get_parser(ev.buf, vim.bo[ev.buf].filetype)
    if parser then
      parser:parse()
    end
    vim.schedule(function()
      local h = vim.treesitter.highlighter.active[ev.buf]
      if h then
        h.parsing = false
        vim.api.nvim__redraw({ buf = ev.buf, valid = false, flush = false })
      end
    end)
  end,
})
