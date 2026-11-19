return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true
    -- Move to the previous buffer
    vim.keymap.set('n', '[b', ':bprevious<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { silent = true, desc = 'Previous buffer' })

    -- Move to the next buffer
    vim.keymap.set('n', ']b', ':bnext<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { silent = true, desc = 'Next buffer' })
    vim.keymap.set('n', ']d', ':bdelete<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { silent = true, desc = 'Close buffer' })
    require("bufferline").setup({})
  end,
}
