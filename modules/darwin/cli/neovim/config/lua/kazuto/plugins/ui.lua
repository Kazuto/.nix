local lualine = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        component_separators = "|",
      },
    })
  end,
}

local indent_blankline = {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("indent_blankline").setup({
      filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
        "lspinfo",
        "TelescopePrompt",
        "TelescopeResults",
      },
      buftype_exclude = {
        "terminal",
        "NvimTree",
      },
      char = "┊",
      show_trailing_blankline_indent = false,
      show_first_indent_level = true,
    })
  end,
}

vim.g.barbar_auto_setup = false

local barbar = {
  "romgrk/barbar.nvim",
  lazy = false,
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbar").setup({
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,

      hide = {
        extensions = false,
      },

      buffer_index = false,
      buffer_number = false,

      maximum_padding = 2,

      icons = {
        buffer_index = true,
        button = "",

        filetype = {
          custom_colors = false,
          enabled = true,
        },

        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },

        separator = { left = "▎", right = "" },

        modified = { button = "●" },
        pinned = { button = "車", filename = true, separator = { right = "" } },
      },

      sidebar_filetypes = {
        NvimTree = true,
        undotree = true,
      },
    })
  end,
  keys = {
    { "<Tab>",   vim.cmd.BufferNext,     { desc = "Next Buffer" } },
    { "<S-Tab>", vim.cmd.BufferPrevious, { desc = "Previous Buffer" } },
    { "<C-x>",   vim.cmd.BufferClose,    { desc = "Close Buffer" } },
  },
}

local dashboard = {
  "glepnir/dashboard-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("dashboard").setup()
  end,
  event = "VimEnter",
}

return {
  lualine,
  indent_blankline,
  barbar,
  dashboard,
}
