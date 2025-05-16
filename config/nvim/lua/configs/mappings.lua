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
