return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	config = function()
	-- 		require("mason-lspconfig").setup({
	-- 			ensure_installed = {
	-- 				"pyright",
	-- 				"lua_ls",
	-- 				"ruff",
	-- 				"gopls",
	-- 				"clangd",
	-- 				"ts_ls",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({})
			lspconfig.gopls.setup({})
			lspconfig.clangd.setup({})
			lspconfig.ts_ls.setup({})
			lspconfig.rust_analyzer.setup({})
			-- lspconfig.postgres_lsp.setup({})
			vim.diagnostic.config({
				virtual_text = false,
			})
			-- Show line diagnostics automatically in hover window
			vim.o.updatetime = 250
			vim.keymap.set(
				"n",
				"<leader>d",
				"<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set("n", "?", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
