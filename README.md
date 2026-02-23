# My nix configuration

# Instructions

## 1. Clone repo

```bash
git clone https://github.com/Kazuto/NixOS.git ~/.dotfiles
```

## 2. Install nix (skip if NixOS)

**Linux**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**macOS**

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## 3. Build your desired configuration

### Amaterasu (Development on Linux)

```bash
sudo nixos-rebuild switch --flake ./#amaterasu
```

### Tsukuyomi (Development on macOS)

```bash
# First build
nix run nix-darwin \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    -- switch --flake ./#tsukuyomi

# Consecutive builds
darwin-rebuild switch --flake ./#tsukuyomi
```

## 4. Stow your dotfiles

```bash
stow --adopt -t ~ .dotfiles
```

## 5. Sketchybar (macOS only)

The status bar uses [SketchyBar](https://github.com/FelixKratz/SketchyBar) with a Lua config via [SbarLua](https://github.com/FelixKratz/SbarLua).

### Install SketchyBar

```bash
brew install FelixKratz/formulae/sketchybar
```

### Install SbarLua

```bash
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua \
  && cd /tmp/SbarLua/ \
  && make install \
  && rm -rf /tmp/SbarLua/
```

This places `sketchybar.so` in `~/.local/share/sketchybar_lua/`.

### Install dependencies

```bash
# App font for workspace window icons
brew tap kvndrsslr/homebrew-formulae
brew install sketchybar-app-font

# Audio device switching (used by the audio item)
brew install switchaudio-osx

# JSON processing
brew install jq
```

### Install fonts

The config uses **JetBrainsMono Nerd Font** (icons) and **SF Pro** (labels). JetBrainsMono Nerd Font is installed via the Nix config. SF Pro can be downloaded from [developer.apple.com/fonts](https://developer.apple.com/fonts/).

### Start SketchyBar

```bash
brew services start sketchybar
```

### Verify

```bash
sketchybar --reload
```

All items should render on the bar. Hover over CPU, memory, network, audio, github, or spotify for popup details.

---

## Neovim Keybindings

Leader key: `Space`

### General

| Mode | Key | Description |
|------|-----|-------------|
| n | `<C-s>` | Save file |
| n | `<leader>w` | Save file |
| n | `<leader>q` | Quit |
| n | `<leader>x` | Save and quit |
| n | `<Esc>` | Clear search highlights |

### Window Management

| Mode | Key | Description |
|------|-----|-------------|
| n | `<C-h/j/k/l>` | Navigate windows |
| n | `<C-Up/Down>` | Resize window height |
| n | `<C-Left/Right>` | Resize window width |
| n | `<leader>sv` | Split window vertical |
| n | `<leader>sh` | Split window horizontal |
| n | `<leader>se` | Equalize split sizes |
| n | `<leader>sx` | Close split |

### Editing

| Mode | Key | Description |
|------|-----|-------------|
| v | `<` / `>` | Indent (keep selection) |
| v | `J` / `K` | Move selection up/down |
| v | `p` | Paste without replacing clipboard |
| v | `y` | Yank maintaining cursor position |
| n | `k` / `j` | Move by display line (respects count) |
| v | `<M-h/l/j/k>` | Move selection left/right/down/up |
| n | `<M-h/l/j/k>` | Move current line left/right/down/up |

### Navigation

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>qn` / `<leader>qp` | Next/prev quickfix item |
| n | `<leader>cn` / `<leader>cp` | Next/prev change |
| n | `<leader>fp` / `<leader>fn` | Prev/next `{` block |
| n | `<leader>zn` / `<leader>zp` | Next/prev fold |

### Telescope (Fuzzy Finder)

| Mode | Key | Description |
|------|-----|-------------|
| n | `ff` | Find files |
| n | `fa` | Find all files (no ignore) |
| n | `fs` | Live grep |
| v | `fs` | Grep visual selection |
| n | `fg` | Multi-grep |
| n | `fc` | Grep word under cursor |
| n | `fb` | Find open buffers |
| v | `fb` | Fuzzy find in current buffer |
| n | `fr` | Resume last search |
| n | `fk` | Find keymaps |
| n | `fx` | Find and execute command |
| n | `ft` | Find todos |
| n | `<leader>?` | Recently opened files |
| n | `Q` | Command history |
| i | `<C-j/k>` | Move selection (in picker) |
| i | `<C-n/p>` | Cycle search history (in picker) |
| i | `<C-q>` | Send all to quickfix (in picker) |
| i | `<M-q>` | Send selected to quickfix (in picker) |

### LSP (active when LSP attaches)

| Mode | Key | Description |
|------|-----|-------------|
| n | `gd` | Go to definition (Telescope) |
| n | `gD` | Go to declaration |
| n | `gr` | Go to references |
| n | `gi` | Go to implementation |
| n | `gt` | Go to type definition |
| n | `K` | Hover documentation |
| n | `grn` | Rename symbol |
| n, v | `gra` | Code actions |
| n | `<leader>d` | Show line diagnostics |
| n | `<leader>dn` / `<leader>dp` | Next/prev diagnostic |
| n | `<leader>rs` | Restart LSP server |
| n | `<leader>rp` | Restart PHPActor |

### File Explorer (nvim-tree)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>ee` | Toggle file explorer |
| n | `<leader>ef` | Reveal current file in explorer |
| n | `<leader>ec` | Collapse explorer |
| n | `<leader>er` | Refresh explorer |

### Buffers (Bufferline)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<Tab>` | Next buffer |
| n | `<S-Tab>` | Previous buffer |
| n | `<leader>bd` | Close buffer |
| n | `<leader>ba` | Close all other buffers |
| n | `<leader>bp` | Pick buffer |

### Git

| Mode | Key | Description |
|------|-----|-------------|
| n | `<F2>` / `<leader>lg` | Open LazyGit |
| n | `<leader>gn` / `<leader>gp` | Next/prev hunk |
| n | `<leader>hp` | Preview hunk |
| n | `<leader>hr` | Reset hunk |
| n | `<leader>hs` | Stage hunk |
| n | `<leader>hu` | Undo stage hunk |
| n | `<leader>hS` | Stage buffer |

### Harpoon

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>ha` | Add file to harpoon |
| n | `<leader>hd` | Remove file from harpoon |
| n | `<leader>hl` | Open harpoon list |

### Terminal (Toggleterm)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>t1` | Toggle terminal 1 |
| n | `<leader>t2` | Toggle terminal 2 |
| n | `<leader>t3` | Toggle terminal 3 |
| n | `<leader>ts` | Select terminal |
| n | `<leader>tx` | Kill terminal |
| t | `<Esc>` | Exit terminal mode |

### Diagnostics / Trouble

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>xw` | Workspace diagnostics |
| n | `<leader>xd` | Document diagnostics |
| n | `<leader>xq` | Quickfix list |
| n | `<leader>xl` | Location list |
| n | `<leader>xt` | Todos in trouble |
| n | `<leader>tn` / `<leader>tp` | Next/prev trouble item |

### Formatting (Conform)

| Mode | Key | Description |
|------|-----|-------------|
| n, v | `<leader>mp` | Format file or selection |

### Sessions (auto-session)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>wr` | Restore session |
| n | `<leader>ws` | Save session |
| n | `<leader>wd` | Delete session |

### OpenCode (AI)

| Mode | Key | Description |
|------|-----|-------------|
| n, x | `<C-a>` | Ask OpenCode |
| n, x | `<C-x>` | Execute OpenCode action |
| n, t | `<C-.>` | Toggle OpenCode |
| n, x | `go` | Add range to OpenCode |
| n | `goo` | Add current line to OpenCode |
| n | `<S-C-u>` / `<S-C-d>` | Scroll OpenCode up/down |

### Markdown

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>tm` | Toggle markdown render |

### CodeSnap

| Mode | Key | Description |
|------|-----|-------------|
| v, x | `<leader>cc` | Copy code screenshot to clipboard |

### Laravel

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>ll` | Laravel picker |
| n | `<leader>la` | Artisan picker |
| n | `<leader>lr` | Routes picker |
| n | `<leader>lm` | Make picker |
| n | `<leader>lc` | Commands picker |
| n | `<leader>lo` | Resources picker |
| n | `<leader>lt` | Actions picker |
| n | `<leader>lp` | Command center |
| n | `<leader>lu` | Artisan hub |
| n | `<leader>lh` | Documentation |
| n | `<C-g>` | View finder |
| n | `gf` | Go to Laravel resource under cursor |
