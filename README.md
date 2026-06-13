# nvim-next

A single-file Neovim configuration targeting **Neovim 0.12+**, using the built-in
`vim.pack` plugin manager (no lazy.nvim) and built-in Treesitter.

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
  `~/.local/share/nvim-next/site/parser/*.so` and symlinks their queries into
  `~/.local/share/nvim-next/site/queries/`. Both directories are always on the
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

```sh
git clone <this-repo> ~/.config/nvim-next
NVIM_APPNAME=nvim-next nvim          # or just `nvim` if this is your default config
```

On first launch:

1. `vim.pack` clones every plugin listed in `init.lua` (revisions tracked in
   `nvim-pack-lock.json`).
2. `require("nvim-treesitter").install({...})` compiles all listed parsers. This needs
   a working **C compiler** (`cc`/`clang`/`gcc`) and `git` on `PATH` — that's the only
   external requirement for Treesitter.
3. The first compile takes a moment; subsequent startups are instant because parsers
   are already installed and `install()` skips them.

If a language isn't highlighting on the new machine, check:

```vim
:checkhealth nvim-treesitter      " parser install + compiler status
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
- **Parser/query install location:** `~/.local/share/nvim-next/site/`
  (`stdpath("data") .. "/site"`)
