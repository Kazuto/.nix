-- Plugin for Neovim to enhance the development experience of Laravel projects
-- https://github.com/adalessa/laravel.nvim
return {
  "adalessa/laravel.nvim",
  dependencies = {
    "tpope/vim-dotenv",
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvimtools/none-ls.nvim",
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
  },
  cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
  keys = {
    { "<leader>la", ":Laravel artisan<CR>", desc = "Laravel Artisan" },
    { "<leader>lr", ":Laravel routes<CR>", desc = "Laravel Application Routes" },
    { "<leader>lm", ":Laravel make<CR>", desc = "Laravel Make" },
    { "<leader>lc", ":Laravel related<CR>", desc = "Laravel Related" },
  },
  event = { "VeryLazy" },
  config = true,
}
