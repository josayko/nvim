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
      require("mini.surround").setup({
        lazy = true,
      })
      require("mini.sessions").setup({})
      require("mini.git").setup({
        lazy = false,
        mappings = {
          status = "<leader>gs",
          blame = "<leader>gb",
          diff = "<leader>gd",
          log = "<leader>gl",
          branch = "<leader>gb",
          commit = "<leader>gc",
          stash = "<leader>gS",
          reset = "<leader>gr",
          remote = "<leader>grm",
        },
      })
      require("mini.diff").setup({
        lazy = true,
        mappings = {
          next_hunk_preview = "]h",
          prev_hunk_preview = "[h",
        },
      })
    end,
  },
}
