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

	-- Mappings.
	map({ "n" }, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "[G]o [D]efinition")

	-- Set up Telescope-specific keymaps
	map({ "n" }, "<leader>li", ":Telescope lsp_implementations<CR>", "[L]ist [I]mplementation")
	map({ "n" }, "<leader>lr", ":Telescope lsp_references<CR>", "[L]ist [R]eferences")
	map({ "n" }, "gs", ":Telescope git_status<CR>", "[G]it [S]tatus")

	-- Set up LSPSaga-specific keymaps
	map({ "n" }, "<leader>lr", "<cmd>Lspsaga rename<CR>", "[R]ename")
	map({ "n" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ctions")
	map({ "n" }, "K", "<cmd>Lspsaga hover_doc<CR>", "[H]over documentation")

	map({ "n" }, "<leader>lD", "<cmd>Lspsaga show_line_diagnostics<CR>", "[D]iagnostics for line")
	map({ "n" }, "<leader>ld", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "[D]iagnostics for cursor")
	map({ "n" }, "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", "[P]eek [d]efinition")
	map({ "n" }, "<leader>lo", "<cmd>Lspsaga outline<CR>", "[O]utline")

	-- map("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostic in buffer")
	-- map("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic in buffer")

	if client.name == "tsserver" then
		map("<leader>rf", ":TypescriptRenameFile<CR>", "[R]ename [File] Typescript")
	end
end

M.on_attach = function(client, bufnr)
	keymaps(client, bufnr)
end

return M
