-- Improved auto-session.lua
return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = false,
      auto_session_suppress_dirs = {
        "~/",
        "~/Development",
        "~/Downloads",
        "/tmp",
      },
      -- pre_save_cmds = { "NvimTreeClose" },
      -- post_restore_cmds = { "NvimTreeOpen" },
    })
  end,
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "[W]orkspace [R]estore" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "[W]orkspace [S]ave" },
    { "<leader>wd", "<cmd>SessionDelete<CR>", desc = "[W]orkspace [D]elete" },
  },
}
