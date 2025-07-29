-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- https://github.com/williamboman/mason.nvim
local mason = {
  "mason-org/mason.nvim",
  version = "^1.0.0", -- explicit v1 lock
  dependencies = {
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" }, -- same here
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")

    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
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
        "volar",
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd",
        "stylua",
        "eslint_d",
        "php-cs-fixer",
        "shellcheck",
        "shfmt",
      },
    })
  end,
}

-- Quickstart configs for Nvim LSP
-- https://github.com/neovim/nvim-lspconfig
local lspconfig = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",
    { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
    "folke/neodev.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local handler = require("kazuto.plugins.lsp.handler")

    local lspconfig = require("lspconfig")

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup_handlers({
      function(server_name)
        local opts = {
          on_attach = handler.on_attach,
          capabilities = handler.capabilities,
        }

        local status, settings = pcall(require, "kazuto.plugins.lsp.settings." .. server_name)
        if status then
          opts = vim.tbl_deep_extend("force", settings, opts)
        end

        lspconfig[server_name].setup(opts)
      end,
    })
  end,
}

-- Improves the Neovim built-in LSP experience.
-- https://github.com/nvimdev/lspsaga.nvim
local lspsaga = {
  "nvimdev/lspsaga.nvim",
  branch = "main",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("lspsaga").setup({
      -- keybinds for navigation in lspsaga window
      scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
      -- use enter to open file with definition preview
      definition = {
        width = 0.4,
        height = 0.6,
      },
      hover = {
        max_width = 0.4,
        max_height = 0.6,
      },
      outline = {
        keys = {
          toggle = "o",
        },
        layout = "float",
      },
      ui = {
        border = "rounded",
        colors = {
          normal_bg = "#1e222a",
        },
      },
      lightbulb = {
        enable = false,
        sign = true,
        enable_in_insert = true,
        sign_priority = 20,
        virtual_text = false,
      },
    })
  end,
  event = "LspAttach",
}

return {
  mason,
  lspconfig,
  lspsaga,
}
