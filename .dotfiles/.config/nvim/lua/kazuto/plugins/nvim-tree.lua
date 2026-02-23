-- File explorer
-- https://github.com/nvim-tree/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      disable_netrw = true,
      hijack_netrw = true,
      open_on_tab = false,
      hijack_cursor = false,
      update_cwd = true,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      -- update_focused_file = {
      -- 	enable = true,
      -- 	update_cwd = true,
      -- 	ignore_list = {},
      -- },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
      view = {
        width = 35,
        side = "right",
        adaptive_size = false,
        relativenumber = true,
      },
      renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        root_folder_label = false,
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              deleted = "",
              untracked = "U",
              ignored = "◌",
            },
            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
            },
          },
        },
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    { "<leader>ef", ":NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
    { "<leader>ec", ":NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
    { "<leader>er", ":NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
  },
}
