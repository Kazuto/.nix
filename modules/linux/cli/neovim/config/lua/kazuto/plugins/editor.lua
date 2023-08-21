vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvimtree = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
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
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      git = {
        enable = true,
        ignore = true,
        timeout = 500,
      },
      view = {
        width = 30,
        adaptive_size = true,
      },
      renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        root_folder_label = false,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
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
      },
    })
  end,
  keys = {
    { "<C-b>", vim.cmd.NvimTreeToggle, { desc = "Toggle Nvim Tree" } },
  },
}

-- Fuzzy finder
local telescope = {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup()

    telescope.load_extension("fzf")
  end,
  keys = {
    { "<leader>ff", ":Telescope find_files<CR>",                                        desc = "[F]ind [F]iles" },
    { "<leader>fa", ":Telescope find_files follow=true no_ingore=true hidden=true<CR>", desc = "[F]ind [A]ll" },
    { "<leader>fs", ":Telescope live_grep<CR>",                                         desc = "[F]ind [W]ord" },
    { "<leader>fc", ":Telescope grep_string<CR>",                                       desc = "[F]ind [C]ursor" },
    { "<leader>fb", ":Telescope buffers<CR>",                                           desc = "[F]ind [B]ufffer" },
    { "<leader>fo", ":Telescope oldfiles<CR>",                                          desc = "[F]ind [O]ld files" },
    { "<leader>fh", ":Telescope help_tags<CR>",                                         desc = "[F]ind [H]elp" },
  },
}

-- Useful plugin to show you pending keybinds
vim.o.timeout = true
vim.o.timeoutlen = 300

local which_key = {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      keys = { "<leader>", '"', "'", "`", "c", "v" },
    })
  end,
}

-- Show changes to a file
local undotree = {
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "[U]ndo Tree" },
  },
}

-- Show definitions etc. !required ctags!
local tagbar = {
  "preservim/tagbar",
  keys = {
    { "<F8>", ":TagbarToggle<CR>", desc = "Toggle Tagbar" },
  },
}

local gitsigns = {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("gitsigns").setup()
  end,
  keys = {
    { "<leader>gp", ":Gitsigns prev_hunk<CR>",    desc = "[G]o to [P]revious Hunk" },
    { "<leader>gn", ":Gitsigns next_hunk<CR>",    desc = "[G]o to [N]ext Hunk" },
    { "<leader>hp", ":Gitsigns preview_hunk<CR>", desc = "[H]unk [P]review" },
    { "<leader>hr", ":Gitsigns reset_hunk<CR>",   desc = "[H]unk [R]eset" },
    { "<leader>hS", ":Gitsigns stage_buffer<CR>", desc = "[S]tage [B]uffer" },
  },
}

local illuminate = {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      under_cursor = false,
    })
  end,
}

return {
  nvimtree,
  telescope,
  which_key,
  undotree,
  tagbar,
  gitsigns,
  illuminate,
}
