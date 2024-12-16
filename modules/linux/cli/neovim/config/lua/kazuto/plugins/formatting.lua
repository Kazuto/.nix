return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				blade = { "blade-formatter" },
				css = { { "prettierd", "prettier" } },
				go = { "goimports", "gofumpt" },
				html = { { "prettierd", "prettier" } },
				javascript = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				lua = { "stylua" },
				markdown = { { "prettierd", "prettier" } },
				php = { "pint" },
				typescript = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				vue = { { "prettierd", "prettier" } },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
