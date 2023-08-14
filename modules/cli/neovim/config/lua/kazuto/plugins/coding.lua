local autopairs = {
  "windwp/nvim-autopairs",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt" },
    })
  end,
  event = "InsertEnter",
}

local cmp = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.opt.completeopt = "menu,menuone,noselect"

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  end,
}

vim.g.codeium_disable_bindings = 1

local codium = {
  "Exafunction/codeium.vim",
  lazy = false,
  keys = {
    {
      "<C-CR>",
      function()
        return vim.fn["codeium#Accept"]()
      end,
      desc = "Accept Suggestion",
      expr = true,
      mode = "i",
    },
    {
      "<C-;>",
      function()
        return vim.fn["codeium#CycleCompletions"](1)
      end,
      desc = "Next Suggestion",
      expr = true,
      noremap = true,
      mode = "i",
    },
    {
      "<C-,>",
      function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      desc = "Previous Suggestion",
      expr = true,
      mode = "i",
    },
    {
      "<C-x>",
      function()
        return vim.fn["codeium#Clear"]()
      end,
      desc = "Clear Suggestions",
      expr = true,
      mode = "i",
    },
  },
}

local comment = {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
  end,
}

-- Align text by characters

vim.g.lion_squeeze_spaces = 1 -- Remove as many spaces as possible when aligning

local lion = {
  "tommcdo/vim-lion",
}

local luasnip = {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    ls.add_snippets("php", {
      ls.parser.parse_snippet("class", "class $1\n{\n    $0\n}"),
      ls.parser.parse_snippet("pubf", "public function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("prif", "private function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("prof", "protected function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("testt", "public function test_$1()\n{\n    $0\n}"),
      ls.parser.parse_snippet("testa", "/** @test */\npublic function $1()\n{\n    $0\n}"),
    })

    ls.add_snippets("typescript", {
      ls.parser.parse_snippet("import", "import $1 from '$0'"),
    })

    ls.add_snippets("vue", {
      ls.parser.parse_snippet("defineProps", "defineProps<{\n  $0\n}>()"),
    })

    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

vim.g.pasta_disabled_filetypes = { "fugitive" }

local pasta = {
  "sickill/vim-pasta",
}

-- Split or join lines of code

vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
vim.g.splitjoin_trailing_comma = 1
vim.g.splitjoin_php_method_chain_full = 1

local splitjoin = {
  "AndrewRadev/splitjoin.vim",
}

local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "bash",
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

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      autopairs = {
        enable = true,
      },
    })
  end,
}

-- Multi-Cursor selection
local vim_visual_multi = {
  "mg979/vim-visual-multi",
}

return {
  autopairs,
  cmp,
  codium,
  comment,
  lion,
  luasnip,
  pasta,
  splitjoin,
  treesitter,
  vim_visual_multi,
}
