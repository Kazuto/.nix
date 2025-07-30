local M = {}

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities()

M.setup = function()
  local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      source = "if_many",
    },
    signs = true,
    update_on_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      source = "always",
      border = "rounded",
    },
  })
end

local function keymaps(client, bufnr)
  local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  -- Navigation
  map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to Definition")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Go to References")
  map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
  map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")

  -- Documentation
  map({ "n" }, "K", vim.lsp.buf.hover, "Show documentation")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Show Signature Help")

  -- Actions
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Actions")

  -- Diagnostics
  map("n", "<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")
  map("n", "<leader>dp", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Previous Diagnostic")
  map("n", "<leader>dn", function()
    vim.diagnostic.jump({ count = 1 })
  end, "Next Diagnostic")

  -- LSP Servers
  map({ "n" }, "<leader>rs", ":LspRestart<CR>", "[R]estart LSP [S]erver")
end

M.on_attach = function(client, bufnr)
  keymaps(client, bufnr)
end

return M
