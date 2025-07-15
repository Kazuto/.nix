local opt = vim.opt

-- LINE NUMBERS

opt.number = true
opt.relativenumber = true

-- TABS & INDENTATION
opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.smarttab = true
opt.expandtab = true
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true -- indent when starting a new line

-- LINE WRAPPING
opt.wrap = false -- disable line wrapping

-- WILDMODE
opt.wildmode = "longest:full,full" -- list all matches and complete till longest common string

-- UNDO AND BACKUP
opt.swapfile = false -- disable swap files
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- set undo directory
opt.undofile = true -- enable undo files
opt.backup = true -- enable backup
opt.backupdir:remove(".") -- remove current directory from backup directory

-- SEARCH
opt.ignorecase = true -- ignore case if written all lowercase
opt.smartcase = true -- if written at least one uppercase, search is case sensitive
opt.hlsearch = false
opt.incsearch = true

-- APPEARANCE
opt.title = true
opt.termguicolors = true -- enable 24-bit RGB color
opt.background = "dark" -- dark or light
opt.signcolumn = "yes" -- always show sign column

opt.scrolloff = 8 -- minimum number of lines to keep above and below the cursor
opt.sidescrolloff = 8 -- minimum number of columns to keep to the left and right of the cursor

opt.updatetime = 50 -- faster completion

opt.colorcolumn = "80" -- highlight column 80

-- SPLIT WINDOWS
opt.splitright = true -- split new window to right
opt.splitbelow = true -- split new window below

-- CONFIRMATION
opt.confirm = true -- ask for confirmation

-- CLIPBOARD
opt.clipboard:append("unnamedplus") -- use system clipboard

-- LISTCHARS
opt.list = true -- enable listchars
opt.listchars = {
  tab = "┊ ",
  trail = "·",
  nbsp = "⎵",
  -- eol = '↲',
  extends = "❯",
  precedes = "❮",
}
