-- Sets the global leader key to space
vim.g.mapleader = " "
-- Sets the local leader key to space
vim.g.maplocalleader = " "
-- Prevents showing extra messages when using completion
vim.opt.shortmess:append("c")
-- Disable displaying mode
vim.opt.showmode = false
-- Sets the height of the command line area at the bottom
vim.opt.cmdheight = 0
-- Use a single global statusline
vim.opt.laststatus = 3
-- Displays the line number for the current line
vim.opt.number = true
-- Displays line numbers relative to the current cursor position
-- vim.opt.relativenumber = true
-- Time in milliseconds to wait for a mapped sequence to complete
vim.opt.timeoutlen = 500
-- Time in milliseconds of inactivity before calling CursorHold or writing to swap
vim.opt.updatetime = 4000
-- Ignores case when searching patterns
vim.opt.ignorecase = true
-- Automatically switches to case-sensitive search if a capital letter is used
vim.opt.smartcase = true
-- Enables 24-bit RGB colors in the terminal
vim.opt.termguicolors = true
-- Default border for floating windows (LSP completion info popup, hover, etc.)
vim.opt.winborder = "rounded"
-- Configures the behavior of the insert mode completion menu
vim.opt.completeopt = "menu,menuone,noselect,popup"
-- Enables the overall completion feature.
vim.opt.autocomplete = true
-- Number of spaces that a <Tab> character represents
vim.opt.tabstop = 2
-- Number of spaces to use for each step of automatic indentation
vim.opt.shiftwidth = 2
-- Number of spaces that a <Tab> counts for during editing operations
vim.opt.softtabstop = 2
-- Converts tabs into spaces when typing
vim.opt.expandtab = true
-- Automatically inserts an extra level of indentation in some cases
vim.opt.smartindent = true
-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line
vim.opt.smarttab = true
-- Prevents the creation of swap files, which are used for recovery in case of a crash
vim.opt.swapfile = false
-- Enables highlighting of the current line
vim.opt.cursorline = true
-- Always show the sign column (for LSP diagnostics, git signs, etc.)
vim.opt.signcolumn = "yes"
-- Enables the use of the mouse in all modes
vim.opt.mouse = "a"
-- Enables the use of the system clipboard
vim.opt.clipboard = "unnamedplus"
-- OCaml ocp-indent configuration
vim.opt.runtimepath:prepend("/Users/josayko/.opam/default/share/ocp-indent/vim")

-- Set floating window maximum width and length
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "single"
	opts.max_width = opts.max_width or 80
	opts.max_height = opts.max_height or 20
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- General Keymaps
-- Use ; to enter command mode without pressing Shift
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Enter command mode" })
-- Navigate between window panes with Ctrl + h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Colorscheme
vim.pack.add({
	{
		src = "https://github.com/rmehri01/onenord.nvim",
		data = {
			theme = "dark",
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
	},
})
vim.cmd("colorscheme onenord")

-- Treesitter (nvim-treesitter "main" branch — the Neovim 0.12+ rewrite).
-- Parsers compile into stdpath("data")/site/parser and queries are symlinked
-- there, so they're always on the runtimepath. Highlighting itself is started
-- per-buffer by the FileType autocmd further down (vim.treesitter.start).
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").setup({})

-- install() skips parsers that are already installed, so this is cheap on
-- startup and only compiles missing ones (runs async in the background).
require("nvim-treesitter").install({
	"bash",
	"c",
	"eex",
	"elixir",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"heex",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"rust",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
})

-- LSP Plugins
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("expert")

vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})

-- Snacks (file explorer + extras)
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
})

require("snacks").setup({
	explorer = {
		enabled = true,
		layout = { position = "left" },
	},
	-- Fuzzy picker — Neovim has no native fuzzy finder, so this is one of the
	-- few places we reach for a plugin. LSP navigation stays native (LspAttach).
	picker = { enabled = true },
})

-- The global `autocomplete = true` is buffer-scoped, so the built-in completion
-- menu otherwise fires inside the picker's prompt buffer too. Disable it there so
-- typing just filters the result list in real time.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("snacks_picker_no_autocomplete", { clear = true }),
	pattern = "snacks_picker_input",
	callback = function(args)
		vim.bo[args.buf].autocomplete = false
	end,
})

require("which-key").setup({})

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()
require("mini.statusline").setup({})

-- Copilot
require("copilot").setup({
	suggestion = {
		enabled = true,
		-- Show ghost text automatically as you type
		auto_trigger = true,
		keymap = {
			-- Accept handled by custom <Tab> mapping below
			accept = false,
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	panel = { enabled = false },
	filetypes = {
		markdown = true,
		help = true,
	},
})

-- Accept Copilot suggestion with <Tab>, otherwise insert a normal Tab
vim.keymap.set("i", "<Tab>", function()
	local copilot = require("copilot.suggestion")
	if copilot.is_visible() then
		copilot.accept()
		return ""
	end
	return "\t"
end, { expr = true, desc = "Accept Copilot suggestion or insert Tab" })

-- Conform
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "golines", "gofmt" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		ocaml = { "ocamlformat" },
	},
	format_on_save = {
		lsp_fallback = true,
		async = false,
	},
})

-- Treesitter syntax highlighting (built-in, Neovim 0.12+)
-- Parsers/queries live in the site dir; this starts highlighting per buffer
-- whenever a parser is available for the filetype (e.g. elixir).
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if pcall(vim.treesitter.language.add, lang) then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
})

-- Use squiggly underlines for diagnostics
vim.cmd([[
  highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl
]])

-- LSP Attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		if not client_id then
			return
		end

		local client = vim.lsp.get_client_by_id(client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client_id, args.buf, {
				autotrigger = true,
			})
		end

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf })
		vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = args.buf })
		vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = args.buf })
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, { buffer = args.buf })
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, { buffer = args.buf })
		vim.keymap.set(
			"n",
			"<leader>cd",
			vim.diagnostic.open_float,
			{ buffer = args.buf, desc = "Show diagnostic details" }
		)
		vim.keymap.set(
			"n",
			"<leader>q",
			vim.diagnostic.setloclist,
			{ buffer = args.buf, desc = "Open diagnostics list" }
		)
	end,
})

-- LSP Status Command
vim.api.nvim_create_user_command("LspStatus", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
		return
	end

	local lines = { "LSP Clients:" }
	for _, client in ipairs(clients) do
		table.insert(lines, string.format("  • %s (id: %d)", client.name, client.id))
		if client.config.root_dir then
			table.insert(lines, string.format("    Root: %s", client.config.root_dir))
		end
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show LSP status for current buffer" })

-- Diagnostics Commands
vim.api.nvim_create_user_command("DiagnosticsAll", function()
	vim.diagnostic.setqflist()
end, { desc = "Show all workspace diagnostics in quickfix list" })

-- File Explorer
vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })

-- Snacks picker (fuzzy finder — no native Neovim equivalent).
-- LSP navigation/diagnostics deliberately stay on native vim.lsp.* / vim.diagnostic.*.
-- Files / buffers
vim.keymap.set("n", "<leader><space>", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })
vim.keymap.set("n", "<leader>o", function()
	Snacks.picker.buffers({
		win = {
			input = {
				keys = {
					["dd"] = "bufdelete",
					["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
				},
			},
			list = { keys = { ["dd"] = "bufdelete" } },
		},
	})
end, { desc = "Buffers" })
-- Grep
vim.keymap.set("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Grep Word/Selection" })
vim.keymap.set("n", "<C-s>", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sr", function()
	Snacks.picker.resume()
end, { desc = "Resume Last Picker" })

-- Which-key
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps" })

-- New UI opt-in
require("vim._core.ui2").enable({})
