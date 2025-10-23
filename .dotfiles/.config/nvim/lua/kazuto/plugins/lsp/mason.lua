return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "bashls",
        "cssls",
        "emmet_ls",
        "gopls",
        "html",
        "intelephense",
        "jsonls",
        "lua_ls",
        "phpactor",
        "tailwindcss",
        "ts_ls",
        "vue_ls",
        "vtsls",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "b0o/schemastore.nvim",
          { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
          "folke/neodev.nvim",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "stylua",
        "eslint_d",
        "php-cs-fixer",
        "shellcheck",
        "shfmt",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
