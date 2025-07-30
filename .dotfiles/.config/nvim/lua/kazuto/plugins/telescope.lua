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
    "tami5/sqlite.lua",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "vendor/",
          "%.lock",
          "dist/",
          "build/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
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
    {
      "<leader>fa",
      ":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      desc = "[F]ind [A]ll",
    },
    { "<leader>fs", ":Telescope live_grep<CR>", desc = "[F]ind [S]tring" },
    { "<leader>fg", require("kazuto.plugins.telescope.multigrep"), desc = "[F]ind [G]rep" },
    { "<leader>fc", ":Telescope grep_string<CR>", desc = "[F]ind [C]ursor" },
    { "<leader>fb", ":Telescope buffers<CR>", desc = "[F]ind [B]uffer" },
    { "<leader>fh", ":Telescope oldfiles<CR>", desc = "[F]ind [H]istory" },
    { "<leader>ft", ":TodoTelescope<CR>", desc = "[F]ind [T]odos" },
    { "<leader>fr", ":Telescope resume<CR>", desc = "[F]ind [R]esume" },
    { "<leader>fk", ":Telescope keymaps<CR>", desc = "[F]ind [K]eymaps" },
    { "<leader>fc", ":Telescope commands<CR>", desc = "[F]ind [C]ommands" },
    { "Q", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
    { "<leader><leader>", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
  },
}
