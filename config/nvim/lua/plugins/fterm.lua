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

		local terminal_o = fterm:new(vim.tbl_deep_extend("force", {}, terminal_window, { ft = "fterm_o" }))
		local terminal_p = fterm:new(vim.tbl_deep_extend("force", {}, terminal_window, { ft = "fterm_p" }))

		local function toggle_default()
			terminal_o:close()
			terminal_p:close()
			fterm.toggle()
		end

		local function toggle_o()
			fterm.close()
			terminal_p:close()
			terminal_o:toggle()
		end

		local function toggle_p()
			fterm.close()
			terminal_o:close()
			terminal_p:toggle()
		end

		local function from_terminal(toggle)
			return function()
				local escape = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
				vim.api.nvim_feedkeys(escape, "n", false)
				vim.schedule(toggle)
			end
		end

		vim.keymap.set("n", "<M-i>", toggle_default, { desc = "Toggle terminal I" })
		vim.keymap.set("t", "<M-i>", from_terminal(toggle_default), { desc = "Toggle terminal I" })
		vim.keymap.set("n", "<M-o>", toggle_o, { desc = "Toggle terminal O" })
		vim.keymap.set("t", "<M-o>", from_terminal(toggle_o), { desc = "Toggle terminal O" })
		vim.keymap.set("n", "<M-p>", toggle_p, { desc = "Toggle terminal P" })
		vim.keymap.set("t", "<M-p>", from_terminal(toggle_p), { desc = "Toggle terminal P" })
	end,
}
