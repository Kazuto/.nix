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
    virtual_text = true,
    signs = true,
    update_on_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      source = true,
      border = "rounded",
    },
  })
end

local function keymaps(client, bufnr)
  local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  map({ "n" }, "gD", vim.lsp.buf.declaration, "[G]o [D]efinition")
  map({ "n" }, "gd", ":Telescope lsp_definitions<CR>", "[L]ist [D]efinitions")
  map({ "n" }, "gR", ":Telescope lsp_references<CR>", "[L]ist [R]eferences")
  map({ "n" }, "gi", ":Telescope lsp_implementations<CR>", "[L]ist [I]mplementation")
  map({ "n" }, "gt", ":Telescope lsp_type_definitions<CR>", "[L]ist [T]ype Definition")
  map({ "n" }, "gs", ":Telescope git_status<CR>", "[G]it [S]tatus")

  map({ "n" }, "K", vim.lsp.buf.hover, "Show documentation")
  -- map({ "n" }, "K", ":Lspsaga hover_doc<CR>", "Show documentation")

  map({ "n" }, "<leader>D", ":Telescope diagnostics bufnr=0<CR>", "[D]iagnostics for file")
  map({ "n" }, "<leader>d", vim.diagnostic.open_float, "[D]iagnostics for line")

  map({ "n" }, "<leader>rn", vim.lsp.buf.rename, "[R]ename")
  map({ "n" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")

  map({ "n" }, "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostic in buffer")
  map({ "n" }, "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic in buffer")

  map({ "n" }, "<leader>rs", ":LspRestart<CR>", "[R]estart LSP [S]erver")
end

M.on_attach = function(client, bufnr)
  keymaps(client, bufnr)
end

return M
