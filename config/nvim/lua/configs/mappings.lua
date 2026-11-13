vim.keymap.set({'n', 'v'}, 'J', '5j', {})
vim.keymap.set({'n', 'v'}, 'K', '5k', {})
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")

-- tagbar
vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true, silent = true })

-- Clear highlighting on Escape in normal mode
vim.keymap.set('n', '<C-i>', ':nohlsearch<CR><C-L>', { noremap = true, silent = true })

-- Terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- Format json
vim.api.nvim_create_user_command('FormatJSON', function()
  vim.cmd('%!jq .')
end, {})

-- replace highlighted text
vim.keymap.set('n', '<leader>c', function()
  -- Get the last searched pattern
  local pattern = vim.fn.getreg('/')
  if pattern == '' then
    print("No previous search pattern.")
    return
  end

  -- Ask the user for the replacement
  local replace = vim.fn.input('Replace "' .. pattern .. '" with: ')
  if replace == '' then
    return -- No input, no replacement
  end

  -- Perform the substitution
  vim.cmd(':%s/\\V' .. vim.fn.escape(pattern, '/') .. '/' .. replace .. '/g')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

-- load the session for the current directory
vim.keymap.set("n", "<leader>ls", function() require("persistence").load() end)

-- select a session to load
vim.keymap.set("n", "<leader>lS", function() require("persistence").select() end)

vim.api.nvim_create_user_command('FixWhitespace', function()
  -- Remove trailing whitespace from all lines
  vim.cmd('%s/[[:space:]]\\+$//ge')
  -- Remove whitespace-only lines
  vim.cmd('%s/^[[:space:]]\\+$//ge')
end, {
  desc = 'Remove trailing whitespace and clean whitespace-only lines'
})

-- Manual config reload command
vim.api.nvim_create_user_command('ReloadConfig', function()
  -- Clear the Lua module cache
  for name, _ in pairs(package.loaded) do
    if name:match('^configs') or name:match('^plugins') then
      package.loaded[name] = nil
    end
  end
  
  -- Reload the configuration
  vim.cmd('luafile ' .. vim.fn.stdpath('config') .. '/init.lua')
  vim.notify('Nvim config reloaded!', vim.log.levels.INFO, { title = 'Config' })
end, {
  desc = 'Manually reload Neovim configuration'
})
