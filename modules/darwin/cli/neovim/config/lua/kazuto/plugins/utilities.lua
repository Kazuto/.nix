-- Quick access to attached files
local harpoon = {
  "theprimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup()
  end,
  keys = {
    { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>",        desc = "[H]arpoon [A]dd" },
    { "<C-e>",     "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "[H]arpoon [L]ist" },
  },
}

-- Show a floating terminal
local toggleterm = {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<F1>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })
  end,
}

return {
  harpoon,
  toggleterm,
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  { "tpope/vim-repeat" },              -- Allow plugins to hook into repeat (.)
  { "tpope/vim-surround" },            -- Replace surrounding quotes or tags
  { "tpope/vim-sleuth" },              -- Automatically detect indentation
  { "christoomey/vim-tmux-navigator" }, -- tmux & split window navigation
}
