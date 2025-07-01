return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only load the plugin when a buffer is read
  opts = {
    -- add any custom options here
    -- for example:
    -- dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- session save path
    -- options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions
  },
}
