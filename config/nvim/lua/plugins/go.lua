return {
   {
     "ray-x/go.nvim",
     dependencies = {  -- optional packages
       "ray-x/guihua.lua",
       "neovim/nvim-lspconfig",
       "nvim-treesitter/nvim-treesitter",
     },
     config = function()
       require("go").setup()
     end,
     event = {"CmdlineEnter"},
     ft = {"go", 'gomod'},
     build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
   },
   -- {
   -- "fatih/vim-go",
   -- config = function()
   --    vim.g.go_doc_keywordprg_enabled = 0
   --    vim.g.go_code_completion_enabled = 0
   --    vim.g.go_fmt_autosave = 0
   --    vim.g.go_highlight_functions_enabled = 1
   --    vim.g.go_highlight_methods_enabled = 1
   --    vim.g.go_highlight_structs_enabled = 1
   --    vim.g.go_highlight_operators_enabled = 1
   --    vim.g.go_highlight_build_constraints_enabled = 1
   --    vim.g.go_highlight_extra_types_enabled = 1
   --    vim.g.go_highlight_array_whitespace_error = 1
   --    vim.g.go_highlight_chan_whitespace_error = 1
   --    vim.g.go_highlight_fields_enabled = 1
   --    vim.g.go_highlight_function_calls_enabled = 1
   --    vim.g.go_highlight_function_parameters_enabled = 1
   --    vim.g.go_highlight_generate_tags_enabled = 1
   --    vim.g.go_highlight_operators_enabled = 1
   --    vim.g.go_highlight_trailing_whitespace_error = 1
   --    vim.g.go_highlight_types_enabled = 1
   --    vim.g.go_highlight_variable_declarations_enabled = 1
   --    vim.g.go_imports_autosave = 0
   --    vim.g.go_mod_fmt_autosave = 0
   --    vim.g.go_def_mapping_enabled = 0
   --    vim.g.go_gopls_enabled = 1
   -- end,
   -- }
}
