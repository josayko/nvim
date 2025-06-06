return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.icons").setup({
        lazy = true,
      })
    end,
  },
}
