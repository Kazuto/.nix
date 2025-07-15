-- Fuzzy finder
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "jonarrien/telescope-cmdline.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { truncate = 1 },
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = "",
        layout_config = {
          prompt_position = "bottom",
        },
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
        file_ignore_patterns = { "node_modules", ".git", "vendor" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")
    telescope.load_extension("ui-select")
    telescope.load_extension("cmdline")
  end,
  keys = {
    { "<leader>ff", ":Telescope find_files<CR>", desc = "[F]ind [F]iles" },
    { "<leader>fa", ":Telescope find_files follow=true no_ingore=true hidden=true<CR>", desc = "[F]ind [A]ll" },
    { "<leader>fs", ":Telescope live_grep<CR>", desc = "[F]ind [S]tring" },
    { "<leader>fg", require("kazuto.plugins.telescope.multigrep"), desc = "[F]ind [G]rep" },
    { "<leader>fc", ":Telescope grep_string<CR>", desc = "[F]ind [C]ursor" },
    { "<leader>fb", ":Telescope buffers<CR>", desc = "[F]ind [B]uffer" },
    { "<leader>fh", ":Telescope oldfiles<CR>", desc = "[F]ind [H]istory" },
    { "<leader>ft", ":TodoTelescope<CR>", desc = "[F]ind [T]odos" },
    { "Q", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
    { "<leader><leader>", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
  },
}
