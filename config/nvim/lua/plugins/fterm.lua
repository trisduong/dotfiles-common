return {
	"numToStr/FTerm.nvim",
	config = function()
		require("FTerm").setup({
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
			border = "single",
		})
		local fterm = require("FTerm")
		local btop = fterm:new({
			ft = "fterm_btop",
			cmd = "btop",
		})
		-- Use this to toggle btop in a floating terminal
		vim.keymap.set("n", "<A-b>", function()
			btop:toggle()
		end)

		local lzd = fterm:new({
			ft = "fterm_lzd",
			cmd = "lazydocker",
		})
		-- Use this to toggle btop in a floating terminal
		vim.keymap.set("n", "<M-l>", function()
			lzd:toggle()
		end)

		vim.keymap.set("n", "<M-i>", '<CMD>lua require("FTerm").toggle()<CR>')
		vim.keymap.set("t", "<M-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
	end,
}
