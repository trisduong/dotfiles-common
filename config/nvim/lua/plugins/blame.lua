return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
		  vim.keymap.set("n", "<C-s>", ":BlameToggle<CR>", {})
    end,
  },
}
