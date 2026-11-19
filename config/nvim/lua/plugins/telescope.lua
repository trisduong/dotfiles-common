return {
   { "smartpde/telescope-recent-files" },
   {
      "nvim-telescope/telescope.nvim",
      branch = "master",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local builtin = require("telescope.builtin")
         function vim.getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg("v")
            vim.fn.setreg("v", {})

            text = string.gsub(text, "\n", "")
            if #text > 0 then
               return text
            else
               return ""
            end
         end

         local keymap = vim.keymap.set
         local tb = require("telescope.builtin")
         local actions = require("telescope.actions")
         local opts = { noremap = true, silent = true }
         require("telescope").setup({
            defaults = {
               file_ignore_patterns = {
                  "static/assets/",
                  "node_modules/",
                  "dist/",
                  "build/",
                  "%.js.map$",
               },
            },
            pickers = {
               buffers = {
                  mappings = {
                     i = { ["<C-d>"] = actions.delete_buffer },
                     n = { ["d"] = actions.delete_buffer },
                  },
               },
            },
         })
         local function open_buffers()
             require("telescope.builtin").buffers()
         end
         keymap("n", "<space>fb", open_buffers, { desc = "Choose buffer" })
         keymap("n", "<leader>bb", open_buffers, { desc = "Choose buffer" })
         keymap("n", "<space>lg", ":Telescope resume<cr>", opts)
         keymap("n", "<space>g", ":Telescope current_buffer_fuzzy_find<cr>", opts)
         keymap("v", "<space>g", function()
            local text = vim.getVisualSelection()
            tb.current_buffer_fuzzy_find({ default_text = text })
         end, opts)

         keymap("n", "<space>G", ":Telescope live_grep<cr>", opts)
         keymap("v", "<space>G", function()
            local text = vim.getVisualSelection()
            tb.live_grep({ default_text = text })
         end, opts)
         vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
         vim.api.nvim_set_keymap(
            "n",
            "<Leader><Leader>",
            [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
            { noremap = true, silent = true }
         )
      end,
   },
   {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
         require("telescope").setup({
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
            },
         })
         require("telescope").load_extension("ui-select")
      end,
   },
}
