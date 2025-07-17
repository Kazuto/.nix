-- Treesitter configurations and abstraction layer for Neovim
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function(_, opts)
    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })

    local treesitter = require("nvim-treesitter.configs")

    vim.g.skip_ts_context_commentstring_module = true

    treesitter.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },

      indent = {
        enable = true,
      },

      autopairs = {
        enable = true,
      },

      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "bash",
        "blade",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "scss",
        "sql",
        "typescript",
        "vue",
        "yaml",
        -- Default
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,
    })

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }
  end,
}
