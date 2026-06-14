# Agent Guidelines for Neovim Configuration (nvim)

## Build/Lint/Test Commands
- **Format Lua**: `stylua init.lua` (tabs, 120 columns — stylua defaults, no config file)
- **No tests**: This is a Neovim config — verify by opening nvim and testing functionality
- **Check syntax**: Open files in nvim to validate Lua syntax

## Design Principles
- **Prefer built-in native Neovim features (latest, 0.12+) over plugins** wherever a native equivalent exists. Examples already in use: native LSP (`vim.lsp.buf.*`) for navigation/hover/rename, `vim.diagnostic.*`, built-in Treesitter (`vim.treesitter.*`), `vim.lsp.completion` (no completion plugin), the new core UI (`vim._core.ui2`).
- **Only reach for a plugin when there is no native equivalent.** The fuzzy picker (snacks.nvim) is the main example — Neovim ships no native fuzzy finder. Do not route things that have a native API (LSP navigation, diagnostics, completion) through a plugin.

## Code Style
- **Indentation**: Tabs (stylua config)
- **Line length**: 120 characters max
- **Imports**: Use `require()` for plugin setup, called immediately after `vim.pack.add`
- **Plugin specs**: Use `vim.pack.add({ { src = "https://github.com/..." } })` format
- **Strings**: Use double quotes for consistency
- **Comments**: Use `--` for single line, avoid unless explaining complex logic

## File Structure
- `init.lua`: Single-file config — all options, plugins, keymaps, and autocmds live here
- `lsp/`: LSP server configurations (e.g., `lua_ls.lua`, `expert.lua`)
- `nvim-pack-lock.json`: Plugin lockfile managed by `vim.pack.add`
- `README.md`: User-facing docs (Treesitter setup, adding languages, cloning to a new machine)

## Plugin Management
- Uses Neovim's built-in `vim.pack.add()` (no lazy.nvim)
- Plugins are loaded eagerly — order matters
- Call `require("plugin").setup()` immediately after the `vim.pack.add` block

## Key Conventions
- Leader key is `<Space>`
- LSP keymaps are buffer-local, set in the `LspAttach` autocmd
- Global keymaps (explorer, which-key) are set at the bottom of `init.lua`
- `vim.lsp.completion.enable` handles LSP completions (built-in, no external completion engine)

## Current Plugins
- `onenord.nvim` — colorscheme
- `nvim-treesitter` (`main` branch) — Treesitter parsers; highlighting started via a `FileType` autocmd (`vim.treesitter.start`)
- `nvim-lspconfig` — LSP server configs
- `mason.nvim` + `mason-lspconfig.nvim` — LSP server installation
- `snacks.nvim` — file explorer (`<leader>e`) + fuzzy picker (file finders `<leader>f*`, grep `<leader>/`/`<leader>s*`, buffers `<leader>o`); LSP navigation stays native
- `which-key.nvim` — keymap popup (`<leader>?`)
- `mini.nvim` — icons + statusline
- `copilot.lua` — AI ghost text suggestions
- `conform.nvim` — formatting on save

## LSP Servers
- `lua_ls` — installed via mason
- `expert` — Elixir LSP (installed externally, not via mason)

## Error Handling
- Use `pcall()` for operations that might fail
- Prefer `vim.notify()` over `print()` for user messages
- Handle missing dependencies gracefully
