-- LEADER (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Shorten function name
function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end

-- general
Map("n", "<leader>gs", vim.cmd.Git, { desc = "[Git] [S]tatus" })
Map("n", "<C-s>", vim.cmd.w, { desc = "[S]ave file" })

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
Map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
Map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- split windows
Map("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertical" })
Map("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontal" })
Map("n", "<leader>se", "<C-w>=", { desc = "[S]plit window [E]qual" })
Map("n", "<leader>sx", ":close<CR>", { desc = "[S]plit window E[x]it" })

-- Maintain the cursor position when yanking a visual selection
Map('v', 'y', 'myy`y')

-- reselect visual selection after indenting
Map('v', '<', '<gv')
Map('v', '>', '>gv')

-- Easy insertion of a trailing ; or , from insert mode
Map('i', ';;', '<Esc>A;<Esc>')
Map('i', ',,', '<Esc>A,<Esc>')

-- paste replace visual selection without copying it
Map('v', 'p', '"_dP')

-- resize with arrows
Map('n', '<C-Up>', ':resize +2<CR>')
Map('n', '<C-Down>', ':resize -2<CR>')
Map('n', '<C-Left>', ':vertical resize -2<CR>')
Map('n', '<C-Right>', ':vertical resize +2<CR>')

-- move text up and down
-- Map('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
-- Map('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
-- Map('n', '<A-j>', ':m .+1<CR>==')
-- Map('n', '<A-k>', ':m .-2<CR>==')
-- Map('v', '<A-j>', ":m '>+1<CR>gv=gv")
-- Map('v', '<A-k>', ":m '<-2<CR>gv=gv")

Map('v', '<J>', ":m '>+1<CR>gv=gv")
Map('v', '<K>', ":m '<-2<CR>gv=gv")
