local api = vim.api

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd("colorscheme catppuccin")

      api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#313244" })

      api.nvim_set_hl(0, "IndentBlanklineChar", {
        fg = api.nvim_get_hl_by_name("LineNr", true).background,
      })

      api.nvim_set_hl(0, 'StatusLineNonText', {
        fg = api.nvim_get_hl_by_name("NonText", true).background,
        bg = api.nvim_get_hl_by_name("StatusLine", true).background,
      })
    end,
  },
}
