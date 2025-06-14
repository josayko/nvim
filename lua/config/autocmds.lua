vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- defaults:
    -- https://neovim.io/doc/user/news-0.11.html#_defaults

    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
    map("<leader>lf", vim.lsp.buf.format, "Format")
    map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

    -- Make LSP references bold
    vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, nocombine = true })
  end,
})
