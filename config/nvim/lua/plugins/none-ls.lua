return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local sources = {
				null_ls.builtins.formatting.stylua,

				null_ls.builtins.diagnostics.cfn_lint,

				null_ls.builtins.diagnostics.commitlint,

				null_ls.builtins.diagnostics.proselint,
				null_ls.builtins.code_actions.proselint,

				null_ls.builtins.diagnostics.hadolint,

				null_ls.builtins.diagnostics.yamllint,

				-- golang
				-- null_ls.builtins.diagnostics.revive,
				-- null_ls.builtins.formatting.golines.with({
				-- 	extra_args = {
				-- 		"--max-len=180",
				-- 		"--base-formatter=gofumpt",
				-- 	},
				-- }),
            -- null_ls.builtins.diagnostics.golangci_lint.with({
            --     args = {
            --         "run",
            --         "--config",
            --         vim.fn.expand("$ROOT/.golangci.yml"),
            --         "--path-prefix",
            --         vim.fn.expand("$ROOT"),
            --         "--out-format",
            --         "json",
            --         "$DIRNAME",
            --     },
            -- }),

				-- deprecated so must use extras
				require("none-ls.formatting.ruff"),
				require("none-ls.diagnostics.ruff"),
			}
			-- local gotest = require("go.null_ls").gotest()
			-- local gotest_codeaction = require("go.null_ls").gotest_action()
			-- local golangci_lint = require("go.null_ls").golangci_lint()
			-- table.insert(sources, gotest)
			-- table.insert(sources, golangci_lint)
			-- table.insert(sources, gotest_codeaction)
			null_ls.setup({ sources = sources, debounce = 1000, default_timeout = 5000 })
			vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, {})
		end,
	},
}
