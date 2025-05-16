vim.g.mapleader = " "

vim.opt.expandtab=true
vim.opt.tabstop=2
vim.opt.softtabstop=2
vim.opt.shiftwidth=2

vim.opt.clipboard:append("unnamedplus")

vim.opt.colorcolumn = "80"

vim.opt.foldmethod = 'indent'  -- Use indentation for folding
vim.opt.foldlevel = 99          -- Start with all folds open
vim.opt.foldenable = true       -- Enable folding

vim.wo.number = true

vim.g.background = "light"

vim.opt.swapfile = false
vim.opt.undofile = true

local opts = { noremap=true, silent=true }
vim.keymap.set("n", "<Leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, opts)
vim.g.copilot_filetypes = {markdown = true}
