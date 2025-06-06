vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false

vim.opt.tabstop = 4 -- Number of visual spaces per TAB
vim.opt.softtabstop = 4 -- Number of spaces inserted when pressing TAB
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation
vim.opt.expandtab = true -- Convert TAB to spaces
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.winborder = "rounded"

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  opts.max_width = opts.max_width or 80 -- Set your desired max width
  opts.max_height = opts.max_height or 20 -- Set your desired max height
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
