function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

Map("n", "<leader>gs", vim.cmd.Git, { desc = "[Git] [S]tatus" })
Map("n", "<C-s>", vim.cmd.w, { desc = "[S]ave file" })

-- Split windows
Map("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertical" })
Map("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontal" })
Map("n", "<leader>se", "<C-w>=", { desc = "[S]plit window [E]qual" })
Map("n", "<leader>sx", ":close<CR>", { desc = "[S]plit window E[x]it" })

-- Reselect visual selection after indenting
Map('v', '<', '<gv')
Map('v', '>', '>gv')

-- Paste replace visual selection without copying it
Map('v', 'p', '"_dP')

-- Resize with arrows
Map('n', '<C-Up>', ':resize +2<CR>')
Map('n', '<C-Down>', ':resize -2<CR>')
Map('n', '<C-Left>', ':vertical resize -2<CR>')
Map('n', '<C-Right>', ':vertical resize +2<CR>')

-- Move text up and down
Map("v", "J", ":m '>+1<CR>gv=gv")
Map("v", "K", ":m '<-2<CR>gv=gv")
