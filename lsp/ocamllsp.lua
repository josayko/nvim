local blink = require("blink.cmp")
return {
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "reason", "dune" },
  root_markers = {
    "*.opam",
    "esy.json",
    "package.json",
    ".merlin",
    "dune",
    "dune-project",
    ".git",
  },
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    {
      textDocument = {
        codeAction = { dynamicRegistration = true },
        completion = { completionItem = { snippetSupport = true } },
      },
    }
  ),
}
