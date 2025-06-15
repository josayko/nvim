return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.icons").setup({
        lazy = true,
        lsp = {
          copilot = { glyph = "" },
        },
      })
      -- mock nvim-web-devicons to use mini.icons instead
      require("mini.icons").mock_nvim_web_devicons()
      require("mini.pairs").setup({
        lazy = true,
      })
      require("mini.sessions").setup({})
    end,
  },
}
