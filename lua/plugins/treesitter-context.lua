return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 0, -- 0 means no limit
      trim_scope = "inner", -- "outer" | "inner" | "both"
      min_window_height = 0, -- set to 0 to disable
      mode = "cursor", -- "cursor" | "topline"
      line_numbers = true,
      multiline_threshold = 20,
      zindex = 20,
      on_attach = nil, -- function to run when the context is attached
    })
  end,
}
