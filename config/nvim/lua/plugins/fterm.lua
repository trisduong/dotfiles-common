return {
	"numToStr/FTerm.nvim",
	config = function()
		local terminal_window = {
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
			border = "single",
		}
		require("FTerm").setup(terminal_window)
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

		local terminal_o = fterm:new(vim.tbl_deep_extend("force", terminal_window, { ft = "fterm_o" }))
		local terminal_p = fterm:new(vim.tbl_deep_extend("force", terminal_window, { ft = "fterm_p" }))

		vim.keymap.set("n", "<M-o>", function()
			terminal_o:toggle()
		end, { desc = "Toggle terminal O" })
		vim.keymap.set("t", "<M-o>", function()
			vim.cmd("stopinsert")
			terminal_o:toggle()
		end, { desc = "Toggle terminal O" })

		vim.keymap.set("n", "<M-p>", function()
			terminal_p:toggle()
		end, { desc = "Toggle terminal P" })
		vim.keymap.set("t", "<M-p>", function()
			vim.cmd("stopinsert")
			terminal_p:toggle()
		end, { desc = "Toggle terminal P" })
	end,
}
