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

        # Maintain cursor position when yanking
        { mode = "v"; key = "y"; action = "myy`y"; }

        # Clear search highlighting
        {
          mode = "n";
          key = "<Esc>";
          action.__raw = ''
            function()
              if vim.v.hlsearch == 1 then
                vim.cmd("nohlsearch")
              end
            end
          '';
          options = { desc = "Clear search"; };
        }

        # Wrapped line navigation
        { mode = "n"; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; }; }
        { mode = "n"; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; }; }

        # Quickfix navigation
        { mode = "n"; key = "<leader>qn"; action = "<cmd>cnext<CR>"; options = { desc = "Next quickfix"; }; }
        { mode = "n"; key = "<leader>qp"; action = "<cmd>cprev<CR>"; options = { desc = "Previous quickfix"; }; }

        # Function/block navigation
        { mode = "n"; key = "<leader>fp"; action = "?{<CR>"; options = { desc = "Previous {"; }; }
        { mode = "n"; key = "<leader>fn"; action = "/{<CR>"; options = { desc = "Next {"; }; }

        # Change navigation
        { mode = "n"; key = "<leader>cp"; action = "<cmd>cprevious<CR>"; options = { desc = "Previous change"; }; }
        { mode = "n"; key = "<leader>cn"; action = "<cmd>cnext<CR>"; options = { desc = "Next change"; }; }

        # Fold navigation
        { mode = "n"; key = "<leader>zn"; action = "zj"; options = { desc = "Next fold"; }; }
        { mode = "n"; key = "<leader>zp"; action = "zk"; options = { desc = "Previous fold"; }; }

        # PHPActor restart
        { mode = "n"; key = "<leader>rp"; action = "<cmd>PhpactorRestart<CR>"; options = { desc = "Restart PHPActor"; }; }

        # Buffer navigation (Bufferline) - matches original config
        {
          mode = "n";
          key = "<Tab>";
          action.__raw = ''
            function()
              if vim.bo.buftype ~= "terminal" then
                vim.cmd("BufferLineCycleNext")
              end
            end
          '';
          options = { desc = "Next buffer"; };
        }
        {
          mode = "n";
          key = "<S-Tab>";
          action.__raw = ''
            function()
              if vim.bo.buftype ~= "terminal" then
                vim.cmd("BufferLineCyclePrev")
              end
            end
          '';
          options = { desc = "Previous buffer"; };
        }
        { mode = "n"; key = "<leader>bd"; action = "<cmd>BufferKill<CR>"; options = { desc = "Close buffer"; }; }
        { mode = "n"; key = "<leader>ba"; action = "<cmd>BufferKillOthers<CR>"; options = { desc = "Close other buffers"; }; }
        { mode = "n"; key = "<leader>bp"; action = "<cmd>BufferLinePick<CR>"; options = { desc = "Pick buffer"; }; }

        # Session management
        { mode = "n"; key = "<leader>wr"; action = "<cmd>SessionRestore<CR>"; options = { desc = "Restore session"; }; }
        { mode = "n"; key = "<leader>ws"; action = "<cmd>SessionSave<CR>"; options = { desc = "Save session"; }; }

        # Terminal (Toggleterm)
        { mode = "n"; key = "<leader>t1"; action = "<cmd>1ToggleTerm<CR>"; options = { desc = "Terminal 1"; }; }
        { mode = "n"; key = "<leader>t2"; action = "<cmd>2ToggleTerm<CR>"; options = { desc = "Terminal 2"; }; }
        { mode = "n"; key = "<leader>t3"; action = "<cmd>3ToggleTerm<CR>"; options = { desc = "Terminal 3"; }; }
        { mode = "t"; key = "<Esc>"; action = "<C-\\><C-n>"; options = { desc = "Exit terminal mode"; }; }

        # Formatting
        { mode = "n"; key = "<leader>mp"; action = "<cmd>lua require('conform').format()<CR>"; options = { desc = "Format file"; }; }
        { mode = "v"; key = "<leader>mp"; action = "<cmd>lua require('conform').format()<CR>"; options = { desc = "Format selection"; }; }

        # Lazygit
        { mode = "n"; key = "<leader>lg"; action = "<cmd>LazyGit<CR>"; options = { desc = "LazyGit"; }; }
        { mode = "n"; key = "<F2>"; action = "<cmd>LazyGit<CR>"; options = { desc = "LazyGit"; }; }

        # Telescope (NO leader key - uses ff, fb, fs, etc.)
        { mode = "n"; key = "<leader>?"; action = "<cmd>Telescope oldfiles<CR>"; options = { desc = "Find recently opened files"; }; }
        { mode = "n"; key = "fb"; action = "<cmd>Telescope buffers<CR>"; options = { desc = "Find buffers"; }; }
        { mode = "n"; key = "ff"; action = "<cmd>Telescope find_files<CR>"; options = { desc = "Find files"; }; }
        { mode = "n"; key = "fa"; action.__raw = "function() require('telescope.builtin').find_files({ follow = true, no_ignore = true, hidden = true }) end"; options = { desc = "Find all files"; }; }
        { mode = "n"; key = "fs"; action = "<cmd>Telescope live_grep<CR>"; options = { desc = "Find string"; }; }
        { mode = "n"; key = "fc"; action = "<cmd>Telescope grep_string<CR>"; options = { desc = "Find word under cursor"; }; }
        { mode = "n"; key = "fr"; action = "<cmd>Telescope resume<CR>"; options = { desc = "Resume telescope"; }; }
        { mode = "n"; key = "fk"; action = "<cmd>Telescope keymaps<CR>"; options = { desc = "Find keymaps"; }; }
        { mode = "n"; key = "fx"; action = "<cmd>Telescope commands<CR>"; options = { desc = "Find commands"; }; }
        { mode = "n"; key = "Q"; action = "<cmd>Telescope command_history<CR>"; options = { desc = "Command history"; }; }

        # File explorer (nvim-tree)
        { mode = "n"; key = "<leader>ee"; action = "<cmd>NvimTreeToggle<CR>"; options = { desc = "Toggle file explorer"; }; }
        { mode = "n"; key = "<leader>ef"; action = "<cmd>NvimTreeFindFileToggle<CR>"; options = { desc = "Toggle explorer on current file"; }; }
        { mode = "n"; key = "<leader>ec"; action = "<cmd>NvimTreeCollapse<CR>"; options = { desc = "Collapse file explorer"; }; }
        { mode = "n"; key = "<leader>er"; action = "<cmd>NvimTreeRefresh<CR>"; options = { desc = "Refresh file explorer"; }; }

        # Harpoon (harpoon2)
        { mode = "n"; key = "<leader>ha"; action.__raw = "function() require('harpoon'):list():add() end"; options = { desc = "Harpoon add file"; }; }
        { mode = "n"; key = "<leader>hh"; action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end"; options = { desc = "Harpoon menu"; }; }
        { mode = "n"; key = "<leader>h1"; action.__raw = "function() require('harpoon'):list():select(1) end"; options = { desc = "Harpoon file 1"; }; }
        { mode = "n"; key = "<leader>h2"; action.__raw = "function() require('harpoon'):list():select(2) end"; options = { desc = "Harpoon file 2"; }; }
        { mode = "n"; key = "<leader>h3"; action.__raw = "function() require('harpoon'):list():select(3) end"; options = { desc = "Harpoon file 3"; }; }
        { mode = "n"; key = "<leader>h4"; action.__raw = "function() require('harpoon'):list():select(4) end"; options = { desc = "Harpoon file 4"; }; }
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
            nil_ls.enable = true;  # Nix LSP
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

        # Telescope - fuzzy finder
        telescope = {
          enable = true;
          extensions = {
            fzf-native.enable = true;
            ui-select.enable = true;
          };
          settings = {
            defaults = {
              path_display = [ "truncate" ];
              prompt_prefix = "   ";
              selection_caret = "  ";
              entry_prefix = "  ";
              initial_mode = "insert";
              selection_strategy = "reset";
              sorting_strategy = "ascending";
              layout_strategy = "horizontal";
              layout_config = {
                horizontal = {
                  prompt_position = "top";
                  preview_width = 0.55;
                  results_width = 0.8;
                };
                vertical = {
                  mirror = false;
                };
                width = 0.87;
                height = 0.80;
                preview_cutoff = 120;
              };
              mappings = {
                i = {
                  "<esc>" = "close";
                  "<C-n>" = "cycle_history_next";
                  "<C-p>" = "cycle_history_prev";
                  "<C-j>" = "move_selection_next";
                  "<C-k>" = "move_selection_previous";
                  "<C-q>".__raw = "require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist";
                  "<M-q>".__raw = "require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist";
                };
              };
              file_ignore_patterns = [
                "node_modules"
                ".git/"
                "vendor/"
                "%.lock"
                "dist/"
                "build/"
              ];
            };
            pickers = {
              find_files = {
                hidden = true;
                find_command = [ "rg" "--files" "--hidden" "--glob" "!**/.git/*" ];
              };
              live_grep = {
                additional_args.__raw = "function() return { '--hidden' } end";
              };
              lsp_definitions = {
                show_line = false;
                trim_text = true;
              };
              lsp_references = {
                show_line = false;
                trim_text = true;
              };
            };
          };
        };

        # UI enhancements - configured via extraConfigLua
        lualine.enable = true;

        # File explorer - floating window
        nvim-tree = {
          enable = true;
          openOnSetup = false;
          settings = {
            disable_netrw = true;
            hijack_netrw = true;
            view = {
              float = {
                enable = true;
                open_win_config = {
                  border = "rounded";
                  relative = "editor";
                };
              };
            };
            diagnostics = {
              enable = true;
              icons = {
                hint = "";
                info = "";
                warning = "";
                error = "";
              };
            };
            git = {
              enable = true;
              ignore = false;
            };
            renderer = {
              highlight_git = true;
              root_folder_label = false;
              group_empty = true;
              icons = {
                show = {
                  file = true;
                  folder = true;
                  folder_arrow = false;
                  git = true;
                };
                glyphs = {
                  git = {
                    unstaged = "";
                    staged = "S";
                    unmerged = "";
                    renamed = "➜";
                    deleted = "";
                    untracked = "U";
                    ignored = "◌";
                  };
                };
              };
              indent_markers = {
                enable = true;
                inline_arrows = true;
                icons = {
                  corner = "└";
                  edge = "│";
                  item = "│";
                  none = " ";
                };
              };
            };
          };
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

        # Surround - Better than mini.surround
        nvim-surround.enable = true;

        # Comments
        comment.enable = true;

        # Indent guides
        indent-blankline = {
          enable = true;
          settings = {
            indent = {
              char = "│";
            };
            scope = {
              enabled = true;
              show_start = false;
              show_end = false;
            };
            exclude = {
              filetypes = [
                "help"
                "dashboard"
                "neo-tree"
                "Trouble"
                "lazy"
                "mason"
                "notify"
                "toggleterm"
              ];
            };
          };
        };


        # Which-key
        which-key = {
          enable = true;
        };

        # Trouble
        trouble.enable = true;

        # Bufferline - buffer tabs
        bufferline = {
          enable = true;
          settings = {
            options = {
              indicator = {
                icon = " ";
              };
              show_close_icon = true;
              tab_size = 0;
              max_name_length = 25;
              offsets = [
                {
                  filetype = "NvimTree";
                  text = "  Files";
                  highlight = "StatusLine";
                  text_align = "left";
                }
              ];
              hover = {
                enabled = true;
                delay = 0;
                reveal = [ "close" ];
              };
              modified_icon = "●";
              diagnostics = "nvim_lsp";
              diagnostics_update_on_event = true;
              diagnostics_indicator.__raw = ''
                function(count, level)
                  local icon = level:match("error") and " " or " "
                  return icon .. count
                end
              '';
              custom_areas = {
                left.__raw = ''
                  function()
                    return {
                      { text = "    ", fg = "#8fff6d" },
                    }
                  end
                '';
              };
              highlights = {
                fill = {
                  bg = {
                    attribute = "bg";
                    highlight = "StatusLine";
                  };
                };
                buffer_selected = {
                  italic = false;
                };
                separator = {
                  fg = {
                    attribute = "bg";
                    highlight = "StatusLine";
                  };
                  bg = {
                    attribute = "bg";
                    highlight = "BufferlineInactive";
                  };
                };
              };
            };
          };
        };

        # Auto-session - session management
        auto-session = {
          enable = true;
          settings = {
            auto_save = true;
            auto_restore = false;
            suppressed_dirs = [ "~/" "~/Downloads" "/tmp" ];
          };
        };

        # Toggleterm - terminal
        toggleterm = {
          enable = true;
          settings = {
            hide_numbers = true;
            start_in_insert = true;
            direction = "float";
            float_opts = {
              border = "rounded";
            };
          };
        };

        # Conform - formatting
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              css = [ "prettierd" ];
              go = [ "goimports" "gofumpt" ];
              html = [ "prettierd" ];
              javascript = [ "prettierd" ];
              json = [ "prettierd" ];
              lua = [ "stylua" ];
              markdown = [ "prettierd" ];
              nix = [ "alejandra" ];  # or use "nixpkgs-fmt"
              php = [ [ "pint" "php-cs-fixer" ] ];
              python = [ "isort" "black" ];
              sh = [ "shfmt" ];
              typescript = [ "prettierd" ];
              vue = [ "prettierd" ];
              yaml = [ "prettierd" ];
            };
            format_on_save = {
              lsp_fallback = true;
              timeout_ms = 1000;
            };
          };
        };

        # Lint
        lint = {
          enable = true;
          lintersByFt = {
            javascript = [ "eslint_d" ];
            typescript = [ "eslint_d" ];
            vue = [ "eslint_d" ];
            php = [ "phpstan" ];
          };
          autoCmd = {
            event = [ "BufEnter" "BufWritePost" "InsertLeave" ];
          };
        };

        # Harpoon - file navigation
        harpoon.enable = true;

        # Vim-tmux-navigator
        vim-tmux-navigator.enable = true;

        # Lazygit integration
        lazygit.enable = true;

        # Luasnip - snippets
        luasnip = {
          enable = true;
          settings = {
            history = true;
            updateevents = "TextChanged,TextChangedI";
          };
          fromVscode = [
            { }
          ];
        };

        # Neoscroll - smooth scrolling
        neoscroll = {
          enable = true;
          settings = {
            hide_cursor = true;
            mappings = [ "<C-u>" "<C-d>" "<C-b>" "<C-f>" ];
          };
        };

        # Render-markdown
        render-markdown.enable = true;

        # Dashboard - start screen
        dashboard = {
          enable = true;
          settings = {
            theme = "hyper";
            config = {
              header = [
                "                                        "
                "                                        "
                "        ..............    ......        "
                "         ............    ......         "
                "              ................          "
                "             ................           "
                "            ......  ....                "
                "             ....   .....               "
                "              ..    .....               "
                "                  ......                "
                "                 ......                 "
                "                 .....                  "
                "                   ..                   "
                "                                        "
                "                                        "
              ];
              week_header.enable = false;
              shortcut = [
                {
                  desc = " New File";
                  group = "@property";
                  key = "n";
                  action = "enew";
                }
                {
                  desc = " Find File";
                  group = "Label";
                  key = "f";
                  action = "Telescope find_files";
                }
                {
                  desc = " Find Text";
                  group = "DiagnosticHint";
                  key = "g";
                  action = "Telescope live_grep";
                }
                {
                  desc = " Recent Files";
                  group = "Number";
                  key = "r";
                  action = "Telescope oldfiles";
                }
              ];
              project = {
                enable = true;
                limit = 3;
              };
              mru = {
                limit = 5;
                cwd_only = true;
              };
              footer = [ "" ];
            };
          };
        };

        # TS-Autotag - auto close HTML tags
        ts-autotag = {
          enable = true;
          settings = {
            opts = {
              enable_close = true;
              enable_rename = true;
              enable_close_on_slash = true;
            };
          };
        };

        # Rainbow delimiters - colorful brackets
        rainbow-delimiters.enable = true;

        # Sleuth - auto detect indentation
        sleuth.enable = true;

        # Go.nvim - enhanced Go support
        go = {
          enable = true;
          settings = { };
        };

        # Visual-multi - multiple cursors
        vim-visual-multi.enable = true;

        # Laravel.nvim - Laravel development tools
        # Note: This is a complex plugin that may need manual Lua config via extraConfigLua

        # Mini plugins collection
        mini = {
          enable = true;
          mockDevIcons = true;  # Make mini.icons compatible with plugins expecting web-devicons
          modules = {
            # Icons - better than web-devicons
            icons = { };

            # Already have comment plugin, but mini.comment works too
            # comment = { };

            # Highlight word under cursor
            cursorword = { };

            # Move lines/selections with Alt+hjkl
            move = {
              mappings = {
                left = "<M-h>";
                right = "<M-l>";
                down = "<M-j>";
                up = "<M-k>";
                line_left = "<M-h>";
                line_right = "<M-l>";
                line_down = "<M-j>";
                line_up = "<M-k>";
              };
            };

            # Split/join arguments, arrays, etc.
            splitjoin = { };

            # Surround selections with quotes, brackets, etc.
            surround = { };

            # Better notifications
            notify = { };

            # Starter screen (alternative to dashboard)
            # starter = { };
          };
        };

        # Snacks - QoL plugins
        snacks = {
          enable = true;
          settings = {
            notifier.enabled = true;
            input.enabled = true;
            scroll.enabled = false;  # We use neoscroll
          };
        };
      };

      # Colorschemes (not plugins!)
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = false;
          integrations = {
            cmp = true;
            gitsigns = true;
            nvimtree = true;
            treesitter = true;
            telescope.enabled = true;
            which_key = true;
          };
        };
      };

      # Custom Lua configuration
      extraConfigLua = ''
        -- Nvim-tree floating window centering
        local HEIGHT_RATIO = 0.8
        local WIDTH_RATIO = 0.5

        require("nvim-tree").setup({
          view = {
            float = {
              enable = true,
              open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                return {
                  border = "rounded",
                  relative = "editor",
                  row = center_y,
                  col = center_x,
                  width = window_w_int,
                  height = window_h_int,
                }
              end,
            },
            width = function()
              return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            end,
          },
        })

        -- LuaSnip custom snippets
        local ls = require("luasnip")

        -- PHP snippets
        ls.add_snippets("php", {
          ls.parser.parse_snippet("class", "class $1\n{\n    $0\n}"),
          ls.parser.parse_snippet("pubf", "public function $1($2): $3\n{\n    $0\n}"),
          ls.parser.parse_snippet("prif", "private function $1($2): $3\n{\n    $0\n}"),
          ls.parser.parse_snippet("prof", "protected function $1($2): $3\n{\n    $0\n}"),
          ls.parser.parse_snippet("testt", "public function test_$1()\n{\n    $0\n}"),
          ls.parser.parse_snippet("testa", "/** @test */\npublic function $1()\n{\n    $0\n}"),
        })

        -- TypeScript snippets
        ls.add_snippets("typescript", {
          ls.parser.parse_snippet("import", "import $1 from '$0'"),
        })

        -- Vue snippets
        ls.add_snippets("vue", {
          ls.parser.parse_snippet("defineProps", "defineProps<{\n  $0\n}>()"),
        })

        -- Lazygit config
        vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yml")

        -- Re-enter terminal mode whenever a lazygit buffer is focused
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*lazygit*",
          callback = function()
            if vim.bo.buftype == "terminal" then
              vim.cmd("startinsert")
            end
          end,
        })

        -- Lualine custom catppuccin theme
        local mocha = require("catppuccin.palettes").get_palette("mocha")
        vim.opt.laststatus = 0

        require("lualine").setup({
          options = {
            icons_enabled = true,
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
            theme = {
              normal = {
                a = { bg = mocha.base, fg = mocha.text, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
              insert = {
                a = { bg = mocha.blue, fg = mocha.base, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
              visual = {
                a = { bg = mocha.peach, fg = mocha.base, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
              replace = {
                a = { bg = mocha.red, fg = mocha.base, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
              command = {
                a = { bg = mocha.green, fg = mocha.base, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
              inactive = {
                a = { bg = mocha.base, fg = mocha.text, gui = "bold" },
                b = { bg = mocha.base, fg = mocha.text },
                c = { bg = mocha.base, fg = mocha.text },
              },
            },
            globalstatus = false,
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = {
              "branch",
              {
                "diff",
                symbols = { added = " ", modified = " ", removed = " " },
              },
              function()
                return "󰅭 " .. vim.pesc(tostring(#vim.tbl_keys(vim.lsp.get_clients())) or "")
              end,
              { "diagnostics", sources = { "nvim_diagnostic" } },
            },
            lualine_c = {},
            lualine_x = {
              { "filename", path = 1 },
            },
            lualine_y = { "filetype" },
            lualine_z = { "progress", "location" },
          },
        })
      '';

      # Additional packages
      extraPackages = with pkgs; [
        # Search tools
        ripgrep
        fd
        fzf

        # Formatters
        prettierd
        stylua
        shfmt
        black
        isort
        alejandra  # Nix formatter (or use nixpkgs-fmt)
        gotools  # provides goimports
        nodePackages.eslint_d

        # Linters
        phpstan

        # Git
        lazygit
      ];
    };
  };
}
