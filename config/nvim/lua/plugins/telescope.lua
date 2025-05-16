return {
  {"smartpde/telescope-recent-files"},
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
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
      local opts = { noremap = true, silent = true }
      defaults = {
        file_ignore_patterns = {
          "static",
        }
      }
      keymap(
        "n", "<space>fb",
        function()
          local opts = {
            attach_mappings = function(_, map)
              -- Map for normal mode in telescope
              map("n", "d", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").delete_buffer(prompt_bufnr)
              end)
              return true
            end,
          }
          require('telescope.builtin').buffers(opts)
        end
      )
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
vim.api.nvim_set_keymap("n", "<Leader><Leader>",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  {noremap = true, silent = true})
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
