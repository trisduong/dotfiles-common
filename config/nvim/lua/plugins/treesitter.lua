return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        -- Auto-install missing parser if it exists in nvim-treesitter (replaces `auto_install = true`)
        if not vim.tbl_contains(ts.get_installed(), lang) then
          if vim.tbl_contains(ts.get_available(), lang) then
            ts.install({ lang })
          end
          return
        end

        -- Enable native highlighting (`highlight = { enable = true }`)
        if pcall(vim.treesitter.start, args.buf, lang) then
          -- Enable treesitter indentation (`indent = { enable = true }`)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
