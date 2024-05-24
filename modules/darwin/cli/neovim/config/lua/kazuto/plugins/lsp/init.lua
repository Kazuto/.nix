local servers = {
	"bashls",
	"emmet_ls",
	"gopls",
	"html",
	"intelephense",
	"jsonls",
	"lua_ls",
	"phpactor",
	"tailwindcss",
	"volar",
}

local mason = {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint_d",
			},
		})
	end,
}

local lspconfig = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/schemastore.nvim",
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local handler = require("kazuto.plugins.lsp.handler")

		for _, server in ipairs(servers) do
			local opts = {
				on_attach = handler.on_attach,
				capabilities = handler.capabilities,
			}

			server = vim.split(server, "@")[1]

			local status, settings = pcall(require, "kazuto.plugins.lsp.settings." .. server)
			if status then
				opts = vim.tbl_deep_extend("force", settings, opts)
			end

			require("lspconfig")[server].setup(opts)
		end
	end,
}

local lspsaga = {
	"glepnir/lspsaga.nvim",
	branch = "main",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("lspsaga").setup({
			-- keybinds for navigation in lspsaga window
			scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
			-- use enter to open file with definition preview
			definition = {
				edit = "<CR>",
			},
			ui = {
				colors = {
					normal_bg = "#022746",
				},
			},
		})
	end,
	event = "LspAttach",
}

return {
	mason,
	lspconfig,
	lspsaga,
}
