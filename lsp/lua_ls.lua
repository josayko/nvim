local blink = require("blink.cmp")
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      workspace = {
        userThirdParty = { vim.fn.expand("~/.local/share/nvim/lsp-addons") },
        checkThirdParty = "Apply",
      },
      runtime = { version = "LuaJIT" },
      diagnostics = {
        disable = {
          "missing-fields",
          "duplicate-set-field",
          "undefined-doc-name",
        },
        globals = {
          "vim",
          "Snacks",
          "love",
        },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    }
  ),
}
