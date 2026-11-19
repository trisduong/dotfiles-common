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
         local action_state = require("telescope.actions.state")
         local opts = { noremap = true, silent = true }

         local function delete_buffer(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selections = picker:get_multi_selection()
            if vim.tbl_isempty(selections) then
               selections = { picker:get_selection() }
            end

            local deleting = {}
            for _, selection in ipairs(selections) do
               deleting[selection.bufnr] = true
            end

            local replacement
            local function get_replacement()
               if replacement and vim.api.nvim_buf_is_valid(replacement) then
                  return replacement
               end

               local buffers = vim.fn.getbufinfo({ buflisted = 1 })
               table.sort(buffers, function(a, b)
                  return a.lastused > b.lastused
               end)
               for _, buffer in ipairs(buffers) do
                  local bufnr = buffer.bufnr
                  if not deleting[bufnr]
                     and vim.api.nvim_buf_is_valid(bufnr)
                     and vim.bo[bufnr].buftype == ""
                     and vim.bo[bufnr].filetype ~= "neo-tree" then
                     replacement = bufnr
                     return replacement
                  end
               end

               replacement = vim.api.nvim_create_buf(true, false)
               return replacement
            end

            picker:delete_selection(function(selection)
               local bufnr = selection.bufnr
               if vim.bo[bufnr].modified then
                  vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
                  return false
               end

               for _, winid in ipairs(vim.api.nvim_list_wins()) do
                  if vim.api.nvim_win_get_buf(winid) == bufnr then
                     local next_bufnr = get_replacement()
                     vim.api.nvim_win_set_buf(winid, next_bufnr)
                     if picker.original_bufnr == bufnr then
                        picker.original_bufnr = next_bufnr
                     end
                  end
               end

               local force = vim.bo[bufnr].buftype == "terminal"
               return pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
            end)
         end

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
                     i = { ["<C-d>"] = delete_buffer },
                     n = { ["d"] = delete_buffer },
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
