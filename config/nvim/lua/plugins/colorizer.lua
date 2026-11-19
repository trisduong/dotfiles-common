return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    options = {
      parsers = {
        names = { enable = false },
        hex = { default = true, rrggbbaa = true },
        css_fn = true,
      },
      display = {
        mode = "background",
      },
    },
  },
}
