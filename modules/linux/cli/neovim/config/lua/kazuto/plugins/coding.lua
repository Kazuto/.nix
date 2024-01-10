local cmp = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		require("luasnip.loaders.from_vscode").lazy_load()

		vim.opt.completeopt = "menu,menuone,noselect"

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- lsp
				{ name = "nvim_lsp_signature_help" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			formatting = {
				format = require("lspkind").cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			experimental = {
				ghost_text = true,
			},
		})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
	end,
}

vim.g.codeium_disable_bindings = 1

local codium = {
	"Exafunction/codeium.vim",
	lazy = false,
	keys = {
		{
			"<C-CR>",
			function()
				return vim.fn["codeium#Accept"]()
			end,
			desc = "Accept Suggestion",
			expr = true,
			mode = "i",
		},
		{
			"<C-;>",
			function()
				return vim.fn["codeium#CycleCompletions"](1)
			end,
			desc = "Next Suggestion",
			expr = true,
			noremap = true,
			mode = "i",
		},
		{
			"<C-,>",
			function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end,
			desc = "Previous Suggestion",
			expr = true,
			mode = "i",
		},
		{
			"<C-x>",
			function()
				return vim.fn["codeium#Clear"]()
			end,
			desc = "Clear Suggestions",
			expr = true,
			mode = "i",
		},
	},
}

local luasnip = {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
		})

		ls.add_snippets("php", {
			ls.parser.parse_snippet("class", "class $1\n{\n    $0\n}"),
			ls.parser.parse_snippet("pubf", "public function $1($2): $3\n{\n    $0\n}"),
			ls.parser.parse_snippet("prif", "private function $1($2): $3\n{\n    $0\n}"),
			ls.parser.parse_snippet("prof", "protected function $1($2): $3\n{\n    $0\n}"),
			ls.parser.parse_snippet("testt", "public function test_$1()\n{\n    $0\n}"),
			ls.parser.parse_snippet("testa", "/** @test */\npublic function $1()\n{\n    $0\n}"),
		})

		ls.add_snippets("typescript", {
			ls.parser.parse_snippet("import", "import $1 from '$0'"),
		})

		ls.add_snippets("vue", {
			ls.parser.parse_snippet("defineProps", "defineProps<{\n  $0\n}>()"),
		})

		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}

vim.g.skip_ts_context_commentstring_module = true

local treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"go",
				"html",
				"javascript",
				"json",
				"markdown",
				"markdown_inline",
				"php",
				"python",
				"scss",
				"sql",
				"typescript",
				"vue",
				"yaml",
				-- Default
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
			},

			autopairs = {
				enable = true,
			},
		})
	end,
}

local projectionist = {
	"tpope/vim-projectionist",
	dependencies = {
		"tpope/vim-dispatch",
	},
	config = function()
		vim.g.projectionist_heuristics = {}
	end,
}

local laravel = {
	"adalessa/laravel.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"tpope/vim-dotenv",
		"MunifTanjim/nui.nvim",
	},
	cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
	keys = {
		{ "<leader>la", ":Laravel artisan<cr>" },
		{ "<leader>lr", ":Laravel routes<cr>" },
		{ "<leader>lm", ":Laravel related<cr>" },
		{
			"<leader>lt",
			function()
				require("laravel.tinker").send_to_tinker()
			end,
			mode = "v",
			desc = "Laravel Application Routes",
		},
	},
	event = { "VeryLazy" },
	config = function()
		require("laravel").setup()
		require("telescope").load_extension("laravel")
	end,
}

local govim = {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup()
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}

return {
	cmp,
	codium,
	luasnip,
	treesitter,
	laravel,
	govim,
}
