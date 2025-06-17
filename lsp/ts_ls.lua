return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  init_options = {
    plugins = {
      {
        -- IMPORTANT: It is crucial to ensure that @vue/typescript-plugin and @vue/language-server are of identical versions
        -- The plugin hould be accessible by the language-server, either globally or in the node_modules folder
        name = "@vue/typescript-plugin",
        -- Change the localtion to the path where the language-server is installed
        location = "/Users/josayko/.local/share/mise/installs/node/22.16.0/lib/node_modules/@vue/language-server",
        languages = { "vue" },
      },
    },
  },
}
