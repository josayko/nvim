return {
  {
    "rmehri01/onenord.nvim",
    opts = {
      theme = "dark", -- or "light"
      borders = true,
      fade_nc = false,
      styles = {
        comments = "italic",
        strings = "NONE",
        keywords = "bold",
        functions = "NONE",
        variables = "NONE",
        diagnostics = "underline",
      },
      disable = {
        background = false,
        float_background = false,
        cursorline = false,
        eob_lines = true,
      },
      inverse = {
        match_paren = false,
      },
      custom_highlights = {},
      custom_colors = {},
    },
    config = function(_, opts)
      require("onenord").setup(opts)
    end,
    priority = 1000, -- ensure it loads before other plugins that might set colors
  },
}
