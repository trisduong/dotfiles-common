return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("git-worktree").setup({
      change_directory_command = "cd",
      update_on_change = true,
      update_on_change_command = "e .",
      clearjumps_on_change = true,
      autopush = false,
    })
    
    require("telescope").load_extension("git_worktree")
    
    -- Key mappings
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- Switch to existing worktree
    keymap("n", "<leader>gw", require("telescope").extensions.git_worktree.git_worktrees, opts)
    
    -- Create new worktree
    keymap("n", "<leader>gW", require("telescope").extensions.git_worktree.create_git_worktree, opts)
  end,
}