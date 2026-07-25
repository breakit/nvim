vim.api.nvim_create_user_command('AddPack', function(opts)
  local repo = opts.args
  if not repo:match '^https?://' then
    repo = 'https://github.com/' .. repo
  end
  vim.pack.add({ src = repo })
  vim.notify('Added pack: ' .. repo, vim.log.levels.INFO)
end, { nargs = 1, desc = 'Add a pack plugin', complete = 'file' })

vim.api.nvim_create_user_command('DelPack', function(opts)
  local name = opts.args
  local packpath = vim.fn.stdpath 'data' .. '/site/pack'
  for _, dir in ipairs({ 'opt', 'start' }) do
    local path = packpath .. '/' .. dir .. '/' .. name
    if vim.fn.isdirectory(path) == 1 then
      vim.fn.delete(path, 'rf')
      vim.notify('Deleted pack: ' .. name .. ' from ' .. dir, vim.log.levels.INFO)
      return
    end
  end
  vim.notify('Pack not found: ' .. name, vim.log.levels.WARN)
end, { nargs = 1, desc = 'Delete a pack plugin', complete = function()
  local packs = {}
  local packpath = vim.fn.stdpath 'data' .. '/site/pack'
  for _, dir in ipairs({ 'start', 'opt' }) do
    local scandir = vim.fn.readdir(packpath .. '/' .. dir)
    for _, name in ipairs(scandir) do
      table.insert(packs, name)
    end
  end
  return packs
end })

vim.api.nvim_create_user_command('UpdatePack', function()
  vim.pack.update(nil, { offline = true })
end, { desc = 'Check for pack updates (offline)' })
