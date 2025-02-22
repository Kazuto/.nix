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
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local config = {
		virtual_text = true,
		update_on_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			source = true,
		},
	}

	vim.diagnostic.config(config)
end

local function keymaps(client, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end

	-- Mappings.
	map("<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", "[D]iagnostics for line")
	map("<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "[D]iagnostics for cursor")
	map("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "[G]o [D]eclaration")
	map("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "[G]o [D]efinition")
	map("gi", ":Telescope lsp_implementations<CR>", "[G]o [I]mplementation")
	map("gr", ":Telescope lsp_references<CR>", "[G]o [R]eferences")
	map("K", "<cmd>Lspsaga hover_doc<CR>", "Documentation cursor")
	map("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "[R]ename")
	map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ctions")
	-- map("<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", "[F]ormat")
	map("pd", "<cmd>Lspsaga peek_definition<CR>", "[P]eek [d]efinition")

	-- map("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostic in buffer")
	-- map("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic in buffer")
	-- map("<leader>o", "<cmd>LSoutlineToggle<CR>", "[O]utline right hand side")

	if client.name == "tsserver" then
		map("<leader>rf", ":TypescriptRenameFile<CR>", "[R]ename [File] Typescript")
	end
end

M.on_attach = function(client, bufnr)
	keymaps(client, bufnr)
end

return M
