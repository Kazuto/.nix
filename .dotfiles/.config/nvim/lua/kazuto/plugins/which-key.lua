vim.o.timeout = true
vim.o.timeoutlen = 300

-- Useful plugin to show you pending keybinds
-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  opts = {
    preset = "modern",
  },
  keys = { "<leader>", '"', "'", "`", "c", "v" },
  event = { "VeryLazy" },
}
