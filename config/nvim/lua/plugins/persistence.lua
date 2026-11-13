return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only load the plugin when a buffer is read
	config = function()
		require("persistence").setup({})
	end,
}
