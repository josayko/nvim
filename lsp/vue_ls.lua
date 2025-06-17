return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  root_markers = {
    "vite.config.ts",
    "tsconfig.json",
    "package.json",
    ".git",
  },
  init_options = {
    vue = {
      -- disable hybrid mode
      hybridMode = false,
    },
  },
}
