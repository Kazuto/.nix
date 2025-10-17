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
      source = true,
      border = "rounded",
    },
  })

  -- Global LSP optimizations for large files and memory usage
  vim.lsp.set_log_level("WARN") -- Reduce log verbosity
  
  -- Increase file size limit to 10MB (from default 5MB)
  vim.g.lsp_file_size_limit = 10 * 1024 * 1024
  
  -- Remove custom code action handler that might cause loops
  
  -- Optimize hover timeout
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      timeout_ms = 2000, -- 2 second timeout
    }
  )
end

local function keymaps(client, bufnr)
  local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  -- Navigation (primarily Intelephense)
  map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("n", "gd", function()
    -- Check if we're in a special buffer type that might cause issues
    local buftype = vim.bo.buftype
    if buftype == "prompt" or buftype == "nofile" then
      vim.notify("Cannot navigate from this buffer type", vim.log.levels.WARN)
      return
    end
    
    -- Try Telescope first, fallback to builtin LSP
    local ok, _ = pcall(function()
      require("telescope.builtin").lsp_definitions({
        show_line = false,
        trim_text = true,
        include_current_line = false,
      })
    end)
    
    if not ok then
      -- Fallback to builtin LSP
      vim.lsp.buf.definition()
    end
  end, "Go to Definition")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Go to References")
  map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
  map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")

  -- Documentation (Intelephense)
  map("n", "K", vim.lsp.buf.hover, "Show Hover Documentation")
  if client.server_capabilities.signatureHelpProvider then
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Show Signature Help")
  end

  -- Refactoring (will use whichever server supports it)
  if client.server_capabilities.renameProvider then
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  end

  if client.server_capabilities.codeActionProvider then
    map({ "n", "v" }, "<leader>ca", function()
      -- Use a simple timeout wrapper around the default code action
      local timer = vim.loop.new_timer()
      local completed = false
      
      timer:start(3000, 0, function()
        if not completed then
          completed = true
          vim.schedule(function()
            vim.notify("Code action request timed out", vim.log.levels.WARN)
          end)
        end
        timer:close()
      end)
      
      vim.lsp.buf.code_action({
        apply = false,
        context = {
          only = { "quickfix", "refactor.extract", "source.organizeImports" }
        }
      })
      
      -- Mark as completed when the action menu appears
      vim.defer_fn(function()
        completed = true
        if timer and not timer:is_closing() then
          timer:close()
        end
      end, 100)
    end, "Code Actions")
  end

  -- Formatting (use conform.nvim instead)
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format Document")
  end

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

  -- Debug which server is handling what
  map("n", "<leader>lc", function()
    pcall(function()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.WARN)
        return
      end

      for _, c in ipairs(clients) do
        local caps = c.server_capabilities or {}
        local msg = string.format(
          [[
%s:
├─ Hover: %s
├─ Completion: %s
├─ Definition: %s
├─ References: %s
├─ Rename: %s
└─ Code Actions: %s]],
          c.name,
          caps.hoverProvider and "✓" or "✗",
          caps.completionProvider and "✓" or "✗",
          caps.definitionProvider and "✓" or "✗",
          caps.referencesProvider and "✓" or "✗",
          caps.renameProvider and "✓" or "✗",
          caps.codeActionProvider and "✓" or "✗"
        )
        vim.notify(msg, vim.log.levels.INFO)
      end
    end)
  end, "LSP Capabilities")
end

M.on_attach = function(client, bufnr)
  -- Check file size and disable LSP for very large files
  local file_size_limit = 5 * 1024 * 1024 -- 5MB
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  
  if file_path and file_path ~= "" then
    local stat = vim.loop.fs_stat(file_path)
    if stat and stat.size > file_size_limit then
      vim.notify(
        string.format("File %s is too large (%dMB), disabling LSP", 
          vim.fn.fnamemodify(file_path, ":t"), 
          math.floor(stat.size / 1024 / 1024)
        ), 
        vim.log.levels.WARN
      )
      vim.lsp.buf_detach_client(bufnr, client.id)
      return
    end
  end

  keymaps(client, bufnr)
end

return M
