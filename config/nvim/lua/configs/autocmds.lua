-- set tab to 3 space when entering a buffer with .lua file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  callback = function()
    vim.opt.shiftwidth = 3
    vim.opt.tabstop = 3
    vim.opt.softtabstop = 3
    vim.opt.expandtab = true  -- Use spaces instead of tabs
    vim.opt.autoindent = true -- Keep indentation level of the previous line
  end,
})

-- set tab to 4 space when entering a buffer with .py file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.py" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true  -- Use spaces instead of tabs
    vim.opt.autoindent = true -- Keep indentation level of the previous line
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.go" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
    vim.opt.autoindent = true
  end,
})

vim.api.nvim_exec([[
  autocmd TermOpen * setlocal scrollback=5000
]], false)
