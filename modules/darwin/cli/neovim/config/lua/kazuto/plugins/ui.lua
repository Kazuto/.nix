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

local highlight = {
  "CursorColumn",
  "Whitespace",
}

local indent_blankline = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = { highlight = highlight, char = "" },
      whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
      },
      scope = { enabled = false },
    })
  end,
}

local barbar = {
  "romgrk/barbar.nvim",
  lazy = false,
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.barbar_auto_setup = false

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
