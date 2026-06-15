# nvim

A single-file Neovim configuration targeting **Neovim 0.12+**, using the built-in
`vim.pack` plugin manager (no lazy.nvim) and built-in Treesitter.

**Philosophy:** prefer native Neovim features over plugins wherever an equivalent
exists — native LSP (`vim.lsp.buf.*`), `vim.diagnostic.*`, built-in Treesitter, and
`vim.lsp.completion` (no completion plugin). Plugins are reserved for gaps with no
native equivalent — chiefly the fuzzy picker (see below), since Neovim ships no
native fuzzy finder.

## File picker & fuzzy finding

Provided by [`snacks.nvim`](https://github.com/folke/snacks.nvim)'s `picker` module
(`Snacks.picker`). LSP navigation deliberately stays on native `vim.lsp.buf.*`, so
the picker is used only for file finding and grep.

| Keymap | Picker |
| --- | --- |
| `<leader><space>` | Smart find files |
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find file in config dir |
| `<leader>fp` | Projects |
| `<leader>o` | Buffers (`dd` / `<C-d>` to delete) |
| `<leader>/` | Live grep |
| `<leader>sw` | Grep word / visual selection |
| `<C-s>` | Grep open buffers |
| `<leader>sb` | Search lines in buffer |
| `<leader>sr` | Resume last picker |
| `<leader>e` | File explorer (`Snacks.explorer`) |

## Treesitter syntax highlighting

Neovim 0.12 ships Treesitter in core, and the old `nvim-treesitter` plugin was
rewritten. The classic `require("nvim-treesitter.configs").setup({ highlight = { enable = true } })`
API **no longer exists**. Highlighting is now something you start yourself.

In this config there are **two independent pieces**, both in `init.lua`:

### 1. Parsers — `nvim-treesitter` (`main` branch)

```lua
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").setup({})

require("nvim-treesitter").install({
  "bash", "c", "eex", "elixir", "go", ... "yaml",
})
```

- The `main` branch is the Neovim 0.12+ rewrite. We pin to it with `version = "main"`.
- `install({...})` compiles the listed grammars into
  `~/.local/share/nvim/site/parser/*.so` and symlinks their queries into
  `~/.local/share/nvim/site/queries/`. Both directories are always on the
  runtimepath, so the parsers/queries are available regardless of plugin load state.
- `install()` **skips parsers that are already installed**, so it's cheap to run on
  every startup — it only downloads/compiles what's missing, in the background.

### 2. Highlighting — a `FileType` autocmd

```lua
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
```

When a buffer's filetype is set, this looks up the matching Treesitter language and,
**if a parser is installed**, starts highlighting for that buffer. It's wrapped in
`pcall` so filetypes without a parser are silently skipped. This is generic — it
works for any installed parser, so you never have to touch the autocmd when adding
a language.

> **The split matters:** the plugin only *provides* parsers/queries. The autocmd is
> what actually *turns highlighting on*. Both must be present.

## Adding syntax highlighting for a new language

1. Add the language name to the `install({...})` list in `init.lua` (keep it
   alphabetical to match the existing style). For example, to add Zig:

   ```lua
   require("nvim-treesitter").install({
     ...
     "yaml",
     "zig",
   })
   ```

2. Restart Neovim (or run `:TSInstall zig` once for the current session). The parser
   compiles in the background; the `FileType` autocmd handles highlighting
   automatically the next time you open a `.zig` file.

To see what's available / installed:

```vim
:lua print(vim.inspect(require("nvim-treesitter").get_installed()))   " installed
:lua print(vim.inspect(require("nvim-treesitter").get_available()))   " all known
```

## Cloning to a new machine

### Prerequisites

The `nvim-treesitter` `main` branch compiles parsers by shelling out to the
[`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli),
so it must be on your `PATH` **before** first launch. Install it with whichever
toolchain you already have:

```sh
npm install -g tree-sitter-cli     # if you have node/npm (also works via mise/nvm)
cargo install tree-sitter-cli      # if you have a Rust toolchain
```

> **Note:** Homebrew's `tree-sitter` formula installs only the C *library*
> (`lib/`, `include/`), **not** the CLI binary — `brew install tree-sitter` alone
> is not enough. Use `npm`/`cargo` as above.

You also need a working **C compiler** (`cc`/`clang`/`gcc`) and `git` on `PATH` —
the CLI invokes the compiler under the hood to build each parser.

If `tree-sitter` is missing, parser installs fail on first launch with:

```
error: Error during "tree-sitter build": ... ENOENT ... (cmd): 'tree-sitter'
```

### First launch

```sh
git clone <this-repo> ~/.config/nvim
nvim          # this is your default config
```

On first launch:

1. `vim.pack` clones every plugin listed in `init.lua` (revisions tracked in
   `nvim-pack-lock.json`).
2. `require("nvim-treesitter").install({...})` compiles all listed parsers via the
   `tree-sitter` CLI (which in turn uses your C compiler).
3. The first compile takes a moment; subsequent startups are instant because parsers
   are already installed and `install()` skips them.

If a language isn't highlighting on the new machine, check:

```vim
:checkhealth nvim-treesitter      " parser install + tree-sitter CLI / compiler status
:InspectTree                       " confirms the parser is producing a tree
:lua print(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)
```

`:InspectTree` working but no colors means the parser is fine and the issue is
highlighting (the autocmd / queries); no tree at all means the parser isn't installed.

## Useful commands

| Command | What it does |
| --- | --- |
| `:TSInstall <lang>` | Install a parser for the current session |
| `:TSUpdate` | Update installed parsers |
| `:InspectTree` | Show the Treesitter parse tree for the current buffer |
| `:Inspect` | Show highlight groups under the cursor |
| `:checkhealth nvim-treesitter` | Diagnose parser/compiler problems |

## Maintenance

- **Update parsers:** `:TSUpdate`
- **Update the plugin:** standard `vim.pack` update flow (tracks the `main` branch)
- **Parser/query install location:** `~/.local/share/nvim/site/`
  (`stdpath("data") .. "/site"`)
