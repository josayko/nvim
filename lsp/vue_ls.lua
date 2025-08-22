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
      hybridMode = false,
    },
    typescript = {
      tsdk = vim.fn.system("npm list -g typescript --parseable --depth=0 2>/dev/null | head -1"):gsub("\n", "")
        .. "/lib",
    },
  },
  on_new_config = function(new_config, new_root_dir)
    local function get_typescript_server_path(root_dir)
      local project_root = vim.fs.find({ "node_modules" }, { path = root_dir, upward = true })[1]
      if project_root then
        local project_ts = project_root .. "/typescript/lib"
        if vim.fn.isdirectory(project_ts) == 1 then
          return project_ts
        end
      end
      return vim.fn.system("npm list -g typescript --parseable --depth=0 2>/dev/null | head -1"):gsub("\n", "")
        .. "/lib"
    end

    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}
