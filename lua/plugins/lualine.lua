return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "echasnovski/mini.nvim",
  },
  config = function()
    require("lualine").setup({
      options = {
        globalstatus = true,
      },
    })
  end,
}
