local lspconfig = require("lspconfig")

-- Load server configurations from the lsp directory
local function load_lsp_config(server_name)
  local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server_name .. ".lua"
  if vim.fn.filereadable(config_path) == 1 then
    return dofile(config_path)
  else
    return {}
  end
end

local servers = {
  "eslint",
  "gopls",
  "lua_ls",
  "pyright",
  "ts_ls",
}

-- Enable standard servers
for _, server in ipairs(servers) do
  local config = load_lsp_config(server)
  lspconfig[server].setup(config)
end

-- Setup Vue.js language server
vim.lsp.enable("vue_ls")

-- Setup Elixir - Expert language server
vim.lsp.enable("expert")

-- -- Setup ESLint with custom configuration
-- local eslint_config = load_lsp_config("eslint")
-- lspconfig.eslint.setup(eslint_config)

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
