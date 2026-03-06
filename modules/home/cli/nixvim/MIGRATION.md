# Nixvim Migration Guide

## Quick Start

1. **Update flake inputs:**
```bash
nix flake update
```

2. **Enable nixvim (choose one method):**

**Option A:** Override in development suite (recommended)
```nix
# Edit modules/home/suites/development/default.nix
neovim = disabled;
nixvim = enabled;
```

**Option B:** Override at system level
```nix
# In systems/aarch64-darwin/tsukuyomi/default.nix
shiro = {
  # ... existing config ...

  cli = {
    neovim = disabled;
    nixvim = enabled;
  };
};
```

3. **Rebuild:**
```bash
darwin-rebuild switch --flake ./#tsukuyomi
```

## What's Included

### Core Features
- LSP servers: bash, css, go, html, json, lua, php, tailwind, typescript, vue
- Treesitter with syntax highlighting
- Autocompletion (nvim-cmp)
- Telescope fuzzy finder
- File explorer (nvim-tree)
- Git integration (gitsigns)
- Catppuccin colorscheme

### Keymaps (Space as leader)
- `<C-s>` / `<leader>w` - Save
- `<leader>q` - Quit
- `<leader>x` - Save and quit
- `<C-h/j/k/l>` - Navigate windows
- `<leader>sv/sh/se/sx` - Split vertical/horizontal/equal/close
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files
- `gd/gr/gi/K` - LSP navigation
- `<leader>ca/rn` - Code action/rename

## Migrating Additional Plugins

### Adding a Plugin
```nix
plugins = {
  # Enable simple plugins
  flash.enable = true;

  # Configure complex plugins
  nvim-colorizer = {
    enable = true;
    settings = {
      user_default_options = {
        RGB = true;
        RRGGBB = true;
        names = false;
      };
    };
  };
};
```

### Adding Custom Keymaps
```nix
keymaps = [
  {
    mode = "n";
    key = "<leader>e";
    action = "<cmd>NvimTreeToggle<CR>";
    options = { desc = "Toggle file explorer"; };
  }
];
```

### Adding Extra LSP Servers
```nix
plugins.lsp.servers = {
  rust_analyzer.enable = true;
  pyright.enable = true;
};
```

### Custom Lua Configuration
```nix
extraConfigLua = ''
  -- Custom Lua code here
  vim.opt.conceallevel = 2
'';
```

## Testing Both Configs Side-by-Side

You can keep both configs during migration:

1. Current Lua config: `~/.config/nvim/`
2. Nixvim config: Enabled via Nix

To test the old config:
```bash
NVIM_APPNAME=nvim-old nvim
```

## Common Plugin Mappings

| Lazy Plugin | Nixvim Plugin |
|-------------|---------------|
| nvim-lspconfig | plugins.lsp |
| nvim-treesitter | plugins.treesitter |
| nvim-cmp | plugins.cmp |
| telescope.nvim | plugins.telescope |
| lualine.nvim | plugins.lualine |
| gitsigns.nvim | plugins.gitsigns |
| nvim-autopairs | plugins.nvim-autopairs |
| Comment.nvim | plugins.comment |
| trouble.nvim | plugins.trouble |

## Finding Plugin Options

Check nixvim documentation:
```bash
# Search available plugins
nix search nixpkgs#vimPlugins.plugin-name

# View plugin options
nix repl
> :lf .
> :e config.programs.nixvim.plugins.<tab>
```

Or visit: https://nix-community.github.io/nixvim/

## Rollback if Needed

If something breaks:
```bash
# Revert to previous generation
darwin-rebuild switch --rollback

# Or re-enable old config
shiro.cli.neovim = enabled;
shiro.cli.nixvim = disabled;
```
