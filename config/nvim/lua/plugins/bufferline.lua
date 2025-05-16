return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true
    -- Move to the previous buffer
    vim.keymap.set('n', '[b', ':bprevious<CR>', { noremap = true, silent = true })

    -- Move to the next buffer
    vim.keymap.set('n', ']b', ':bnext<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', ']d', ':bdelete<CR>', { noremap = true, silent = true })
    require("bufferline").setup({})
  end,
}
