-- An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- https://github.com/mfussenegger/nvim-lint
return {
  "mfussenegger/nvim-lint",
  -- event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      php = { "phpstan" },
      python = { "pylint" },
      typescript = { "eslint_d" },
      vue = { "eslint_d" },
      sh = { "shellcheck" }, -- Add this for shell linting
      bash = { "shellcheck" }, -- Also for bash files
    }

    -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    --
    -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    -- 	group = lint_augroup,
    -- 	callback = function()
    -- 		lint.try_lint()
    -- 	end,
    -- })

    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "[C]ode [L]int" })
  end,
}
