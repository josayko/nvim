vim.lsp.enable({
  "gopls",
  "lua_ls",
  "pyright",
  "ts_ls",
  "vue_ls",
  "eslint",
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = false,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

function Toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

vim.keymap.set("n", "<leader>ds", "<cmd>lua Toggle_diagnostics()<cr>", { desc = "Toggle diagnostics" })
