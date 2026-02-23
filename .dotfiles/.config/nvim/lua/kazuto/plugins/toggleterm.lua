-- Multi-terminal manager
-- https://github.com/akinsho/toggleterm.nvim
return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>t1", "<cmd>1ToggleTerm<cr>", desc = "[T]erminal [1]" },
    { "<leader>t2", "<cmd>2ToggleTerm<cr>", desc = "[T]erminal [2]" },
    { "<leader>t3", "<cmd>3ToggleTerm<cr>", desc = "[T]erminal [3]" },
    { "<leader>ts", "<cmd>TermSelect<cr>", desc = "[T]erminal [S]elect" },
    { "<leader>tx", "<cmd>bd!<cr>", desc = "[T]erminal kill" },
  },
  config = function()
    require("toggleterm").setup({
      size = 15,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
    })

    -- Exit terminal mode with Esc
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  end,
}
