-- Keep indentation when pasting
-- https://github.com/RRethy/vim-pasta
return {
  "sickill/vim-pasta",
  config = function()
    vim.g.pasta_disabled_filetypes = { "fugitive" }
  end,
}
