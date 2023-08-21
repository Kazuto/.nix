local servers = {
  "bashls",
  "emmet_ls",
  "eslint",
  "html",
  "intelephense",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  -- "yamlls",
  "volar",
}

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

    for _, server in ipairs(servers) do
      local opts = {
        on_attach = handler.on_attach,
        capabilities = handler.capabilities,
      }

      server = vim.split(server, "@")[1]

      local status, settings = pcall(require, "kazuto.plugins.lsp.settings." .. server)
      if status then
        opts = vim.tbl_deep_extend("force", settings, opts)
      end

      require("lspconfig")[server].setup(opts)
    end
  end,
}

local null_ls = {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
    local code_actions = null_ls.builtins.code_actions

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
      debug = false,
      sources = {
        code_actions.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js" })
          end,
        }),
        diagnostics.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js" })
          end,
        }),
        formatting.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js" })
          end,
        }),

        code_actions.shellcheck,

        diagnostics.actionlint,
        diagnostics.codespell,
        diagnostics.dotenv_linter,
        diagnostics.editorconfig_checker,

        diagnostics.phpstan,
        diagnostics.shellcheck,
        diagnostics.trail_space.with({
          disabled_filetypes = { "NvimTree" },
        }),

        formatting.beautysh,
        formatting.jq,
        formatting.pint,
        formatting.prettierd.with({
          extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        }),
        formatting.stylua,
      },
    })
  end,
}
local lspsaga = {
  "glepnir/lspsaga.nvim",
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
        edit = "<CR>",
      },
      ui = {
        colors = {
          normal_bg = "#022746",
        },
      },
    })
  end,
  event = "LspAttach",
}

local mason = {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })
  end,
}

return {
  lspconfig,
  null_ls,
  lspsaga,
  mason,
}
