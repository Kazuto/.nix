{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.nixvim;
in
{
  options.shiro.cli.nixvim = with types; {
    enable = mkBoolOpt false "Whether or not to enable nixvim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      # Global options
      opts = {
        # Line numbers
        number = true;
        relativenumber = true;

        # Tabs and indentation
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;

        # Line wrapping
        wrap = false;
        linebreak = true;

        # Search settings
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        incsearch = true;

        # Appearance
        termguicolors = true;
        background = "dark";
        signcolumn = "yes";
        cursorline = true;
        scrolloff = 8;
        sidescrolloff = 8;

        # Behavior
        mouse = "a";
        clipboard = "unnamedplus";
        completeopt = "menu,menuone,noselect";
        splitright = true;
        splitbelow = true;
        swapfile = false;
        backup = false;
        undofile = true;
        updatetime = 250;
        timeoutlen = 300;

        # Folding
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
        foldenable = false;
      };

      # Global variables
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      # Keymaps
      keymaps = [
        # General
        { mode = "n"; key = "<C-s>"; action = "<cmd>w<CR>"; options = { desc = "Save file"; }; }
        { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options = { desc = "Save file"; }; }
        { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options = { desc = "Quit"; }; }
        { mode = "n"; key = "<leader>x"; action = "<cmd>x<CR>"; options = { desc = "Save and quit"; }; }

        # Window navigation
        { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options = { desc = "Navigate left"; }; }
        { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options = { desc = "Navigate down"; }; }
        { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options = { desc = "Navigate up"; }; }
        { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options = { desc = "Navigate right"; }; }

        # Window resize
        { mode = "n"; key = "<C-Up>"; action = "<cmd>resize -2<CR>"; }
        { mode = "n"; key = "<C-Down>"; action = "<cmd>resize +2<CR>"; }
        { mode = "n"; key = "<C-Left>"; action = "<cmd>vertical resize -2<CR>"; }
        { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<CR>"; }

        # Split windows
        { mode = "n"; key = "<leader>sv"; action = "<C-w>v"; options = { desc = "Split vertical"; }; }
        { mode = "n"; key = "<leader>sh"; action = "<C-w>s"; options = { desc = "Split horizontal"; }; }
        { mode = "n"; key = "<leader>se"; action = "<C-w>="; options = { desc = "Equal splits"; }; }
        { mode = "n"; key = "<leader>sx"; action = "<cmd>close<CR>"; options = { desc = "Close split"; }; }

        # Better indenting
        { mode = "v"; key = "<"; action = "<gv"; }
        { mode = "v"; key = ">"; action = ">gv"; }

        # Move text up and down
        { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
        { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }

        # Better paste
        { mode = "v"; key = "p"; action = ''"_dP''; }

        # Clear search highlighting
        { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options = { desc = "Clear search"; }; }
      ];

      # Plugins
      plugins = {
        # LSP
        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            cssls.enable = true;
            gopls.enable = true;
            html.enable = true;
            jsonls.enable = true;
            lua_ls.enable = true;
            phpactor.enable = true;
            tailwindcss.enable = true;
            ts_ls.enable = true;
            volar.enable = true;
          };
          keymaps = {
            diagnostic = {
              "<leader>j" = "goto_next";
              "<leader>k" = "goto_prev";
            };
            lspBuf = {
              "gd" = "definition";
              "gD" = "declaration";
              "gi" = "implementation";
              "gr" = "references";
              "K" = "hover";
              "<leader>ca" = "code_action";
              "<leader>rn" = "rename";
            };
          };
        };

        # Treesitter
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
            incremental_selection.enable = true;
          };
        };

        # Autocompletion
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
        };

        # Telescope
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = {
              action = "find_files";
              options = { desc = "Find files"; };
            };
            "<leader>fg" = {
              action = "live_grep";
              options = { desc = "Live grep"; };
            };
            "<leader>fb" = {
              action = "buffers";
              options = { desc = "Find buffers"; };
            };
            "<leader>fh" = {
              action = "help_tags";
              options = { desc = "Help tags"; };
            };
            "<leader>fr" = {
              action = "oldfiles";
              options = { desc = "Recent files"; };
            };
          };
        };

        # UI enhancements
        lualine = {
          enable = true;
          settings = {
            options = {
              theme = "auto";
              section_separators = {
                left = "";
                right = "";
              };
              component_separators = {
                left = "";
                right = "";
              };
            };
          };
        };

        # File explorer
        nvim-tree = {
          enable = true;
          openOnSetup = false;
          autoClose = false;
        };

        # Git integration
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = false;
            signs = {
              add.text = "│";
              change.text = "│";
              delete.text = "_";
              topdelete.text = "‾";
              changedelete.text = "~";
              untracked.text = "┆";
            };
          };
        };

        # Autopairs
        nvim-autopairs.enable = true;

        # Comments
        comment.enable = true;

        # Indent guides
        indent-blankline = {
          enable = true;
          settings = {
            scope.enabled = true;
          };
        };

        # Colorscheme
        catppuccin = {
          enable = true;
          settings = {
            flavour = "mocha";
            transparent_background = false;
          };
        };

        # Which-key
        which-key = {
          enable = true;
        };

        # Trouble
        trouble.enable = true;

        web-devicons.enable = true;
      };

      # Colorscheme
      colorscheme = "catppuccin";

      # Additional packages
      extraPackages = with pkgs; [
        ripgrep
        fd
        fzf
      ];
    };
  };
}
