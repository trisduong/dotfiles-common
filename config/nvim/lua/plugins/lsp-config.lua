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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
         vim.lsp.config('lua_ls', {
           settings = {
             Lua = {
               runtime = {
                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                 version = 'LuaJIT',
               },
               diagnostics = {
                 -- Get the language server to recognize the `vim` global
                 globals = {'vim'},
               },
               workspace = {
                 -- Make the server aware of Neovim runtime files
                 library = vim.api.nvim_get_runtime_file("", true),
               },
               -- Do not send telemetry data containing a randomized but unique identifier
               telemetry = {
                 enable = false,
               },
             },
           },
         })
			-- lspconfig.lua_ls.setup({
			-- 	capabilities = capabilities,
			-- })

         -- vim.lsp.config('ty', {
         --   settings = {
         --     ty = {
         --       -- ty language server settings go here
         --     }
         --   }
         -- })
         -- Enable the copilot language server
         vim.lsp.enable('copilot')

         vim.api.nvim_create_autocmd('LspAttach', {
           callback = function(args)
             local client = vim.lsp.get_client_by_id(args.data.client_id)
             if client and client:supports_method('textDocument/inlineCompletion') then
               vim.lsp.inline_completion.enable(true, { bufnr = args.buf })

               -- Accept inline suggestion with <C-Space>
               vim.keymap.set('i', '<C-Space>', function()
                 if not vim.lsp.inline_completion.get() then
                   return '<C-Space>'
                 end
               end, { expr = true, buffer = args.buf, desc = 'Accept inline completion' })

               -- Dismiss inline suggestion with <C-e>
               vim.keymap.set('i', '<C-e>', function()
                 vim.lsp.inline_completion.select({ count = 0 })
               end, { buffer = args.buf, desc = 'Dismiss inline completion' })
             end
           end,
         })

         local lifecycle_group = vim.api.nvim_create_augroup('LspLifecycle', { clear = true })
         vim.api.nvim_create_autocmd('LspDetach', {
           group = lifecycle_group,
           callback = function(args)
             local client_id = args.data.client_id
             vim.schedule(function()
               local client = vim.lsp.get_client_by_id(client_id)
               if client and next(client.attached_buffers) == nil then
                 client:stop()
               end
             end)
           end,
         })

         -- Required: Enable the language server
         -- vim.lsp.enable('ty')
         vim.lsp.config('pyrefly', {
           cmd = { 'pyrefly', 'lsp' },
           filetypes = { 'python' },
           root_markers = { 'pyrefly.toml', 'pyproject.toml', 'setup.py', '.git' },
         })

         -- 2. Linting, import sorting, and formatting
         vim.lsp.config('ruff', {
           cmd = { 'ruff', 'server' },
           filetypes = { 'python' },
           root_markers = { 'ruff.toml', '.ruff.toml', 'pyproject.toml', '.git' },
         })

         vim.lsp.enable({ 'pyrefly', 'ruff' })
         vim.lsp.config(
            'ts_ls',
            {
               capabilities = capabilities,
               settings = {
                  ["typescript"] = {
                     inlayHints = {
                        includeInlayParameterNameHints = "none", -- "none" | "literals" | "all"
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = false,
                        includeInlayFunctionLikeReturnTypeHints = false,
                        includeInlayEnumMemberValueHints = false,
                     },
                  },
               },
            }
         )
         vim.lsp.enable('ts_ls')
         vim.lsp.config('gopls', {
           settings = {
             gopls = {
               hints = {
                 assignVariableTypes = true,
                 compositeLiteralFields = true,
                 constantValues = true,
                 functionTypeParameters = true,
                 parameterNames = true,
                 rangeVariableTypes = true,
               },
             },
           },
         })
			-- lspconfig.clangd.setup({})
         vim.lsp.config('clangd', {})
         vim.lsp.config('rust_analyzer', {
           settings = {
             ["rust-analyzer"] = {
               cargo = {
                 loadOutDirsFromCheck = true,
               },
             },
           },
         })
			-- lspconfig.ts_ls.setup({})
			-- lspconfig.rust_analyzer.setup({})
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
      vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
         vim.diagnostic.config({
           virtual_text = false,
           update_in_insert = false,
         })
		end,
	},
}
