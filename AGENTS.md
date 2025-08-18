# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands
- **Format Lua**: `stylua .` (uses stylua.toml config: 2 spaces, 120 columns)
- **No tests**: This is a Neovim config - verify by opening nvim and testing functionality
- **Check syntax**: Open files in nvim to validate Lua syntax

## Code Style
- **Indentation**: 2 spaces (stylua config), but vim options use 4 spaces
- **Line length**: 120 characters max
- **Imports**: Use `require()` at top of files, group core before plugins
- **Tables**: Prefer arrays for plugin specs `{ "plugin/name", opts = {} }`
- **Strings**: Use double quotes for consistency
- **Functions**: Snake_case for global functions, camelCase for local
- **Variables**: Snake_case for vim options, camelCase for local vars
- **Comments**: Use `--` for single line, avoid unless explaining complex logic

## File Structure
- `init.lua`: Main entry point, requires config modules in order
- `lua/config/`: Core vim settings (options, keymaps, autocmds)
- `lua/core/`: Core functionality (lazy, lsp)
- `lua/plugins/`: Plugin configurations as separate files
- `lsp/`: LSP server configurations

## Error Handling
- Use `pcall()` for operations that might fail
- Prefer vim.notify() over print() for user messages
- Handle missing dependencies gracefully in plugin configs