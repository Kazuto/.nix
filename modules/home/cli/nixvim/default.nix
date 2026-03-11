{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.shiro; let
  cfg = config.shiro.cli.nixvim;
in {
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

      # Additional vim options
      opts.autoread = true; # Required for opencode plugin

      # Keymaps
      keymaps = [
        # General
        {
          mode = "n";
          key = "<C-s>";
          action = "<cmd>w<CR>";
          options = {desc = "Save file";};
        }
        {
          mode = "n";
          key = "<leader>w";
          action = "<cmd>w<CR>";
          options = {desc = "Save file";};
        }
        {
          mode = "n";
          key = "<leader>q";
          action = "<cmd>q<CR>";
          options = {desc = "Quit";};
        }
        {
          mode = "n";
          key = "<leader>x";
          action = "<cmd>x<CR>";
          options = {desc = "Save and quit";};
        }

        # Window navigation
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          options = {desc = "Navigate left";};
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          options = {desc = "Navigate down";};
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          options = {desc = "Navigate up";};
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          options = {desc = "Navigate right";};
        }

        # Window resize
        {
          mode = "n";
          key = "<C-Up>";
          action = "<cmd>resize -2<CR>";
        }
        {
          mode = "n";
          key = "<C-Down>";
          action = "<cmd>resize +2<CR>";
        }
        {
          mode = "n";
          key = "<C-Left>";
          action = "<cmd>vertical resize -2<CR>";
        }
        {
          mode = "n";
          key = "<C-Right>";
          action = "<cmd>vertical resize +2<CR>";
        }

        # Split windows
        {
          mode = "n";
          key = "<leader>sv";
          action = "<C-w>v";
          options = {desc = "Split vertical";};
        }
        {
          mode = "n";
          key = "<leader>sh";
          action = "<C-w>s";
          options = {desc = "Split horizontal";};
        }
        {
          mode = "n";
          key = "<leader>se";
          action = "<C-w>=";
          options = {desc = "Equal splits";};
        }
        {
          mode = "n";
          key = "<leader>sx";
          action = "<cmd>close<CR>";
          options = {desc = "Close split";};
        }

        # Better indenting
        {
          mode = "v";
          key = "<";
          action = "<gv";
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
        }

        # Move text up and down
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<CR>gv=gv";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<CR>gv=gv";
        }

        # Better paste
        {
          mode = "v";
          key = "p";
          action = ''"_dP'';
        }

        # Maintain cursor position when yanking
        {
          mode = "v";
          key = "y";
          action = "myy`y";
        }

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
          options = {desc = "Clear search";};
        }

        # Wrapped line navigation
        {
          mode = "n";
          key = "k";
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            expr = true;
            silent = true;
          };
        }
        {
          mode = "n";
          key = "j";
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            expr = true;
            silent = true;
          };
        }

        # Quickfix navigation
        {
          mode = "n";
          key = "<leader>qn";
          action = "<cmd>cnext<CR>";
          options = {desc = "Next quickfix";};
        }
        {
          mode = "n";
          key = "<leader>qp";
          action = "<cmd>cprev<CR>";
          options = {desc = "Previous quickfix";};
        }

        # Function/block navigation
        {
          mode = "n";
          key = "<leader>fp";
          action = "?{<CR>";
          options = {desc = "Previous {";};
        }
        {
          mode = "n";
          key = "<leader>fn";
          action = "/{<CR>";
          options = {desc = "Next {";};
        }

        # Change navigation
        {
          mode = "n";
          key = "<leader>cp";
          action = "<cmd>cprevious<CR>";
          options = {desc = "Previous change";};
        }
        {
          mode = "n";
          key = "<leader>cn";
          action = "<cmd>cnext<CR>";
          options = {desc = "Next change";};
        }

        # Fold navigation
        {
          mode = "n";
          key = "<leader>zn";
          action = "zj";
          options = {desc = "Next fold";};
        }
        {
          mode = "n";
          key = "<leader>zp";
          action = "zk";
          options = {desc = "Previous fold";};
        }

        # PHPActor restart
        {
          mode = "n";
          key = "<leader>rp";
          action = "<cmd>PhpactorRestart<CR>";
          options = {desc = "Restart PHPActor";};
        }

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
          options = {desc = "Next buffer";};
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
          options = {desc = "Previous buffer";};
        }
        {
          mode = "n";
          key = "<leader>bd";
          action = "<cmd>BufferKill<CR>";
          options = {desc = "Close buffer";};
        }
        {
          mode = "n";
          key = "<leader>ba";
          action = "<cmd>BufferKillOthers<CR>";
          options = {desc = "Close other buffers";};
        }
        {
          mode = "n";
          key = "<leader>bp";
          action = "<cmd>BufferLinePick<CR>";
          options = {desc = "Pick buffer";};
        }

        # Session management
        {
          mode = "n";
          key = "<leader>wr";
          action = "<cmd>SessionRestore<CR>";
          options = {desc = "Restore session";};
        }
        {
          mode = "n";
          key = "<leader>ws";
          action = "<cmd>SessionSave<CR>";
          options = {desc = "Save session";};
        }

        # Terminal (Toggleterm)
        {
          mode = "n";
          key = "<leader>t1";
          action = "<cmd>1ToggleTerm<CR>";
          options = {desc = "Terminal 1";};
        }
        {
          mode = "n";
          key = "<leader>t2";
          action = "<cmd>2ToggleTerm<CR>";
          options = {desc = "Terminal 2";};
        }
        {
          mode = "n";
          key = "<leader>t3";
          action = "<cmd>3ToggleTerm<CR>";
          options = {desc = "Terminal 3";};
        }
        {
          mode = "t";
          key = "<Esc>";
          action = "<C-\\><C-n>";
          options = {desc = "Exit terminal mode";};
        }

        # Formatting
        {
          mode = "n";
          key = "<leader>mp";
          action = "<cmd>lua require('conform').format()<CR>";
          options = {desc = "Format file";};
        }
        {
          mode = "v";
          key = "<leader>mp";
          action = "<cmd>lua require('conform').format()<CR>";
          options = {desc = "Format selection";};
        }

        # Lazygit
        {
          mode = "n";
          key = "<leader>lg";
          action = "<cmd>LazyGit<CR>";
          options = {desc = "LazyGit";};
        }
        {
          mode = "n";
          key = "<F2>";
          action = "<cmd>LazyGit<CR>";
          options = {desc = "LazyGit";};
        }

        # Telescope (NO leader key - uses ff, fb, fs, etc.)
        {
          mode = "n";
          key = "<leader>?";
          action = "<cmd>Telescope oldfiles<CR>";
          options = {desc = "Find recently opened files";};
        }
        {
          mode = "n";
          key = "fb";
          action = "<cmd>Telescope buffers<CR>";
          options = {desc = "Find buffers";};
        }
        {
          mode = "n";
          key = "ff";
          action = "<cmd>Telescope find_files<CR>";
          options = {desc = "Find files";};
        }
        {
          mode = "n";
          key = "fa";
          action.__raw = "function() require('telescope.builtin').find_files({ follow = true, no_ignore = true, hidden = true }) end";
          options = {desc = "Find all files";};
        }
        {
          mode = "n";
          key = "fs";
          action = "<cmd>Telescope live_grep<CR>";
          options = {desc = "Find string";};
        }
        {
          mode = "n";
          key = "fg";
          action.__raw = "function() _G.telescope_multigrep() end";
          options = {desc = "Find with multigrep";};
        }
        {
          mode = "n";
          key = "fc";
          action = "<cmd>Telescope grep_string<CR>";
          options = {desc = "Find word under cursor";};
        }
        {
          mode = "n";
          key = "ft";
          action = "<cmd>TodoTelescope<CR>";
          options = {desc = "Find todos";};
        }
        {
          mode = "n";
          key = "fr";
          action = "<cmd>Telescope resume<CR>";
          options = {desc = "Resume telescope";};
        }
        {
          mode = "n";
          key = "fk";
          action = "<cmd>Telescope keymaps<CR>";
          options = {desc = "Find keymaps";};
        }
        {
          mode = "n";
          key = "fx";
          action = "<cmd>Telescope commands<CR>";
          options = {desc = "Find commands";};
        }
        {
          mode = "n";
          key = "Q";
          action = "<cmd>Telescope command_history<CR>";
          options = {desc = "Command history";};
        }

        # File explorer (nvim-tree)
        {
          mode = "n";
          key = "<leader>ee";
          action = "<cmd>NvimTreeToggle<CR>";
          options = {desc = "Toggle file explorer";};
        }
        {
          mode = "n";
          key = "<leader>ef";
          action = "<cmd>NvimTreeFindFileToggle<CR>";
          options = {desc = "Toggle explorer on current file";};
        }
        {
          mode = "n";
          key = "<leader>ec";
          action = "<cmd>NvimTreeCollapse<CR>";
          options = {desc = "Collapse file explorer";};
        }
        {
          mode = "n";
          key = "<leader>er";
          action = "<cmd>NvimTreeRefresh<CR>";
          options = {desc = "Refresh file explorer";};
        }

        # Harpoon (harpoon2)
        {
          mode = "n";
          key = "<leader>ha";
          action.__raw = "function() require('harpoon'):list():add() end";
          options = {desc = "Harpoon add file";};
        }
        {
          mode = "n";
          key = "<leader>hh";
          action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end";
          options = {desc = "Harpoon menu";};
        }
        {
          mode = "n";
          key = "<leader>h1";
          action.__raw = "function() require('harpoon'):list():select(1) end";
          options = {desc = "Harpoon file 1";};
        }
        {
          mode = "n";
          key = "<leader>h2";
          action.__raw = "function() require('harpoon'):list():select(2) end";
          options = {desc = "Harpoon file 2";};
        }
        {
          mode = "n";
          key = "<leader>h3";
          action.__raw = "function() require('harpoon'):list():select(3) end";
          options = {desc = "Harpoon file 3";};
        }
        {
          mode = "n";
          key = "<leader>h4";
          action.__raw = "function() require('harpoon'):list():select(4) end";
          options = {desc = "Harpoon file 4";};
        }

        # CodeSnap - code screenshots
        {
          mode = ["v" "x"];
          key = "<leader>cc";
          action = "<Esc><cmd>CodeSnap<CR>";
          options = {desc = "Save code snapshot";};
        }

        # Opencode - Claude integration
        {
          mode = ["n" "x"];
          key = "<C-a>";
          action.__raw = "function() require('opencode').ask('@this: ', { submit = true }) end";
          options = {desc = "Ask opencode";};
        }
        {
          mode = ["n" "x"];
          key = "<C-x>";
          action.__raw = "function() require('opencode').select() end";
          options = {desc = "Execute opencode action";};
        }
        {
          mode = ["n" "t"];
          key = "<C-.>";
          action.__raw = "function() require('opencode').toggle() end";
          options = {desc = "Toggle opencode";};
        }
        {
          mode = ["n" "x"];
          key = "go";
          action.__raw = "function() return require('opencode').operator('@this ') end";
          options = {
            desc = "Add range to opencode";
            expr = true;
          };
        }
        {
          mode = "n";
          key = "goo";
          action.__raw = "function() return require('opencode').operator('@this ') .. '_' end";
          options = {
            desc = "Add line to opencode";
            expr = true;
          };
        }
        {
          mode = "n";
          key = "<S-C-u>";
          action.__raw = "function() require('opencode').command('session.half.page.up') end";
          options = {desc = "Scroll opencode up";};
        }
        {
          mode = "n";
          key = "<S-C-d>";
          action.__raw = "function() require('opencode').command('session.half.page.down') end";
          options = {desc = "Scroll opencode down";};
        }
        {
          mode = "n";
          key = "+";
          action = "<C-a>";
          options = {
            desc = "Increment under cursor";
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "-";
          action = "<C-x>";
          options = {
            desc = "Decrement under cursor";
            noremap = true;
          };
        }

        # Laravel keybindings (only active in PHP/Blade files)
        {
          mode = "n";
          key = "<leader>ll";
          action.__raw = "function() Laravel.pickers.laravel() end";
          options = {desc = "Laravel: Open Laravel Picker";};
        }
        {
          mode = "n";
          key = "<C-g>";
          action.__raw = "function() Laravel.commands.run('view:finder') end";
          options = {desc = "Laravel: Open View Finder";};
        }
        {
          mode = "n";
          key = "<leader>la";
          action.__raw = "function() Laravel.pickers.artisan() end";
          options = {desc = "Laravel: Open Artisan Picker";};
        }
        {
          mode = "n";
          key = "<leader>lt";
          action.__raw = "function() Laravel.commands.run('actions') end";
          options = {desc = "Laravel: Open Actions Picker";};
        }
        {
          mode = "n";
          key = "<leader>lr";
          action.__raw = "function() Laravel.pickers.routes() end";
          options = {desc = "Laravel: Open Routes Picker";};
        }
        {
          mode = "n";
          key = "<leader>lh";
          action.__raw = "function() Laravel.run('artisan docs') end";
          options = {desc = "Laravel: Open Documentation";};
        }
        {
          mode = "n";
          key = "<leader>lm";
          action.__raw = "function() Laravel.pickers.make() end";
          options = {desc = "Laravel: Open Make Picker";};
        }
        {
          mode = "n";
          key = "<leader>lc";
          action.__raw = "function() Laravel.pickers.commands() end";
          options = {desc = "Laravel: Open Commands Picker";};
        }
        {
          mode = "n";
          key = "<leader>lo";
          action.__raw = "function() Laravel.pickers.resources() end";
          options = {desc = "Laravel: Open Resources Picker";};
        }
        {
          mode = "n";
          key = "<leader>lp";
          action.__raw = "function() Laravel.commands.run('command_center') end";
          options = {desc = "Laravel: Open Command Center";};
        }
        {
          mode = "n";
          key = "<leader>lu";
          action.__raw = "function() Laravel.commands.run('hub') end";
          options = {desc = "Laravel Artisan hub";};
        }
      ];

      # Plugins
      plugins = {
        # LSP
        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            cssls.enable = true;

            # Go LSP with enhanced settings
            gopls = {
              enable = true;
              extraOptions = {
                settings = {
                  gopls = {
                    analyses = {
                      unusedparams = true;
                    };
                    staticcheck = true;
                    gofumpt = true;
                  };
                };
              };
            };

            html.enable = true;

            # JSON with SchemaStore
            jsonls = {
              enable = true;
              extraOptions = {
                settings = {
                  json = {
                    schemas.__raw = "require('schemastore').json.schemas()";
                    validate = {enable = true;};
                  };
                };
              };
            };

            # Lua LSP with Neovim-specific config
            lua_ls = {
              enable = true;
              extraOptions = {
                settings = {
                  Lua = {
                    diagnostics = {
                      globals = ["vim"];
                    };
                    workspace = {
                      library.__raw = ''
                        {
                          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                          [vim.fn.stdpath("config") .. "/lua"] = true,
                        }
                      '';
                    };
                  };
                };
              };
            };

            nil_ls.enable = true; # Nix LSP

            # PHPActor - focused on refactoring
            phpactor = {
              enable = true;
              extraOptions = {
                init_options = {
                  "language_server_phpstan.enabled" = false;
                  "code_transform.import_globals" = true;
                  "language_server_psalm.enabled" = false;
                  "indexer.enabled_watchers" = ["php"];
                  "indexer.exclude_patterns" = [
                    "**/node_modules/**"
                    "**/build/**"
                    "**/storage/**"
                    "**/cache/**"
                    "**/.git/**"
                    "**/phpstan/**"
                    "**/*resultCache*"
                    "**/*.cache"
                    "**/bootstrap/cache/**"
                  ];
                  "indexer.poll_time" = 5000;
                  "completion.dedupe" = true;
                  "completion_worse.snippets" = false;
                  "worse_reflection.enable_cache" = true;
                  "language_server.diagnostics_on_update" = false;
                  "language_server.diagnostics_on_open" = false;
                  "language_server.diagnostics_on_save" = false;
                  "language_server_worse_reflection.diagnostics.enable" = false;
                };
                onAttach.__raw = ''
                  function(client, bufnr)
                    -- Disable most capabilities, let Intelephense handle them
                    client.server_capabilities.completionProvider = false
                    client.server_capabilities.hoverProvider = false
                    client.server_capabilities.documentSymbolProvider = false
                    client.server_capabilities.workspaceSymbolProvider = false
                    client.server_capabilities.definitionProvider = false
                    client.server_capabilities.declarationProvider = false
                    client.server_capabilities.implementationProvider = false
                    client.server_capabilities.referencesProvider = false
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    client.server_capabilities.diagnosticProvider = false
                    client.server_capabilities.publishDiagnostics = false

                    -- Disable diagnostic handlers
                    client.handlers = client.handlers or {}
                    client.handlers["textDocument/publishDiagnostics"] = function() end
                  end
                '';
              };
            };

            # Tailwind CSS with extended filetypes
            tailwindcss = {
              enable = true;
              filetypes = [
                "html"
                "css"
                "scss"
                "sass"
                "less"
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
                "vue"
                "svelte"
                "blade"
                "twig"
                "erb"
                "handlebars"
                "hbs"
                "mustache"
                "templ"
                "astro"
                "markdown"
                "mdx"
              ];
              extraOptions = {
                settings = {
                  tailwindCSS = {
                    validate = true;
                    lint = {
                      cssConflict = "warning";
                      invalidApply = "error";
                      invalidConfigPath = "error";
                      invalidScreen = "error";
                      invalidTailwindDirective = "error";
                      invalidVariant = "error";
                      recommendedVariantOrder = "warning";
                    };
                    classAttributes = [
                      "class"
                      "className"
                      "classList"
                      "ngClass"
                      ":class"
                      "class:list"
                    ];
                    experimental = {
                      classRegex = [
                        "tw`([^`]*)"
                        ''tw="([^"]*)''
                        "tw={'([^'}]*)"
                        "tw\\.\\w+`([^`]*)"
                        "tw\\(.*?\\)`([^`]*)"
                      ];
                    };
                  };
                };
              };
            };

            # TypeScript with Vue plugin support
            ts_ls = {
              enable = true;
              filetypes = [
                "vue"
                "javascript"
                "javascriptreact"
                "javascript.jsx"
                "typescript"
                "typescriptreact"
                "typescript.tsx"
              ];
              extraOptions = {
                init_options = {
                  plugins = [
                    {
                      name = "@vue/typescript-plugin";
                      location = "/nix/store/wlwwcvx2k8fd599446y5ggijkq0skhgq-vue-language-server-3.2.4/lib/language-tools/packages/language-server";
                      languages = ["vue"];
                    }
                  ];
                };
              };
            };

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
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
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
              path_display = ["truncate"];
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
                find_command = ["rg" "--files" "--hidden" "--glob" "!**/.git/*"];
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
            filters = {
              dotfiles = false;
              git_ignored = false;
              custom = [];
            };
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

        # Which-key with modern preset
        which-key = {
          enable = true;
          settings = {
            preset = "modern";
            triggers = [
              {
                __unkeyed-1 = "<auto>";
                mode = "nxso";
              }
              {
                __unkeyed-1 = "f";
                mode = "n";
              }
            ];
            spec = [
              {
                __unkeyed-1 = "f";
                group = "Find";
              }
            ];
          };
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
                reveal = ["close"];
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
            suppressed_dirs = ["~/" "~/Downloads" "/tmp"];
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
              css = ["prettierd"];
              go = ["goimports" "gofumpt"];
              html = ["prettierd"];
              javascript = ["prettierd"];
              json = ["prettierd"];
              lua = ["stylua"];
              markdown = ["prettierd"];
              nix = ["alejandra"]; # or use "nixpkgs-fmt"
              php = [["pint" "php-cs-fixer"]];
              python = ["isort" "black"];
              sh = ["shfmt"];
              typescript = ["prettierd"];
              vue = ["prettierd"];
              yaml = ["prettierd"];
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
            javascript = ["eslint_d"];
            typescript = ["eslint_d"];
            vue = ["eslint_d"];
            php = ["phpstan"];
          };
          autoCmd = {
            event = ["BufEnter" "BufWritePost" "InsertLeave"];
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
            {}
          ];
        };

        # Neoscroll - smooth scrolling
        neoscroll = {
          enable = true;
          settings = {
            hide_cursor = true;
            mappings = ["<C-u>" "<C-d>" "<C-b>" "<C-f>"];
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
              footer = [""];
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
          settings = {};
        };

        # Visual-multi - multiple cursors
        vim-visual-multi.enable = true;

        # Laravel.nvim - Laravel development tools
        # Note: This is a complex plugin that may need manual Lua config via extraConfigLua

        # Todo Comments - highlight and search for todo comments
        todo-comments = {
          enable = true;
          settings = {
            signs = true;
            keywords = {
              FIX = {
                icon = " ";
                color = "error";
                alt = ["FIXME" "BUG" "FIXIT" "ISSUE"];
              };
              TODO = {
                icon = " ";
                color = "info";
              };
              HACK = {
                icon = " ";
                color = "warning";
              };
              WARN = {
                icon = " ";
                color = "warning";
                alt = ["WARNING" "XXX"];
              };
              PERF = {
                icon = " ";
                alt = ["OPTIM" "PERFORMANCE" "OPTIMIZE"];
              };
              NOTE = {
                icon = " ";
                color = "hint";
                alt = ["INFO"];
              };
            };
          };
        };

        # Mini plugins collection
        mini = {
          enable = true;
          mockDevIcons = true; # Make mini.icons compatible with plugins expecting web-devicons
          modules = {
            # Icons - better than web-devicons
            icons = {};

            # Already have comment plugin, but mini.comment works too
            # comment = { };

            # Highlight word under cursor
            cursorword = {};

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
            splitjoin = {};

            # Surround selections with quotes, brackets, etc.
            surround = {};

            # Better notifications
            notify = {};

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
            scroll.enabled = false; # We use neoscroll
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
        -- Telescope multigrep custom picker
        local multigrep_setup = function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local make_entry = require("telescope.make_entry")
          local conf = require("telescope.config").values
          local flatten = vim.tbl_flatten

          return function(opts)
            opts = opts or {}
            opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
            opts.shortcuts = opts.shortcuts or {
              ["v"] = "*.vue",
              ["t"] = "*.{ts,js}",
              ["c"] = "*.css",
            }
            opts.pattern = opts.pattern or "%s"

            local finder = finders.new_async_job({
              command_generator = function(prompt)
                if not prompt or prompt == "" then
                  return nil
                end

                local pieces = vim.split(prompt, "  ")
                local args = { "rg" }

                if pieces[1] then
                  table.insert(args, "-e")
                  table.insert(args, pieces[1])
                end

                if pieces[2] then
                  table.insert(args, "-g")
                  local pattern
                  if opts.shortcuts[pieces[2]] then
                    pattern = opts.shortcuts[pieces[2]]
                  else
                    pattern = pieces[2]
                  end
                  table.insert(args, string.format(opts.pattern, pattern))
                end

                return flatten({
                  args,
                  { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
                })
              end,
              entry_maker = make_entry.gen_from_vimgrep(opts),
              cwd = opts.cwd,
            })

            pickers.new(opts, {
              debounce = 100,
              prompt_title = "Live Grep (with shortcuts)",
              finder = finder,
              previewer = conf.grep_previewer(opts),
              sorter = require("telescope.sorters").empty(),
            }):find()
          end
        end

        -- Make multigrep available globally
        _G.telescope_multigrep = multigrep_setup()

        -- Auto-close help/quickfix windows with 'q'
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
          callback = function()
            vim.cmd([[
              nnoremap <silent> <buffer> q :close<CR>
              set nobuflisted
            ]])
          end,
        })

        -- Auto-create directories when saving
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
          callback = function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end,
        })

        -- BufferKill command (from LunarVim)
        local function buf_kill(kill_command, bufnr, force)
          kill_command = kill_command or "bd"
          local bo = vim.bo
          local api = vim.api
          local fmt = string.format
          local fnamemodify = vim.fn.fnamemodify

          if bufnr == 0 or bufnr == nil then
            bufnr = api.nvim_get_current_buf()
          end

          local bufname = api.nvim_buf_get_name(bufnr)

          if not force then
            local warning
            if bo[bufnr].modified then
              warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ":t"))
            elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
              warning = fmt([[Terminal %s will be killed]], bufname)
            end
            if warning then
              vim.ui.input({
                prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
              }, function(choice)
                if choice and choice:match("ye?s?") then
                  force = true
                end
              end)
              if not force then
                return
              end
            end
          end

          local windows = vim.tbl_filter(function(win)
            return api.nvim_win_get_buf(win) == bufnr
          end, api.nvim_list_wins())

          if #windows == 0 then
            return
          end

          if force then
            kill_command = kill_command .. "!"
          end

          local buffers = vim.tbl_filter(function(buf)
            return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
          end, api.nvim_list_bufs())

          if #buffers > 1 then
            for i, v in ipairs(buffers) do
              if v == bufnr then
                local prev_buf_idx = i == 1 and (#buffers - 1) or (i - 1)
                local prev_buffer = buffers[prev_buf_idx]
                for _, win in ipairs(windows) do
                  api.nvim_win_set_buf(win, prev_buffer)
                end
              end
            end
          end

          if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
            vim.cmd(string.format("%s %d", kill_command, bufnr))
          end
        end

        -- BufferKillOthers command
        local function buf_kill_others()
          local current_buf = vim.api.nvim_get_current_buf()
          local buffers = vim.tbl_filter(function(buf)
            return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= current_buf
          end, vim.api.nvim_list_bufs())

          for _, buf in ipairs(buffers) do
            buf_kill("bd", buf, false)
          end
        end

        vim.api.nvim_create_user_command("BufferKill", function()
          buf_kill("bd")
        end, { force = true })

        vim.api.nvim_create_user_command("BufferKillOthers", function()
          buf_kill_others()
        end, { force = true })

        -- PhpactorRestart command
        vim.api.nvim_create_user_command("PhpactorRestart", function()
          for _, client in pairs(vim.lsp.get_clients()) do
            if client.name == "phpactor" then
              client.stop()
              vim.notify("Stopping PHPActor...", vim.log.levels.INFO)
            end
          end

          vim.defer_fn(function()
            vim.cmd("LspStart phpactor")
            vim.notify("PHPActor restarted", vim.log.levels.INFO)
          end, 1000)
        end, { force = true })

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

        -- nvim-highlight-colors setup
        require("nvim-highlight-colors").setup({
          render = "virtual",
          virtual_symbol = "●",
          virtual_symbol_prefix = "",
          virtual_symbol_suffix = " ",
          virtual_symbol_position = "inline",
          enable_hex = true,
          enable_short_hex = true,
          enable_rgb = true,
          enable_hsl = true,
          enable_var_usage = true,
          enable_named_colors = true,
          enable_tailwind = true,
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

        -- CodeSnap setup
        local ok_codesnap, codesnap = pcall(require, "codesnap")
        if ok_codesnap then
          codesnap.setup({
            save_path = "~/Pictures",
            has_breadcrumbs = true,
            bg_color = "#535c68",
            watermark = "",
            bg_padding = 20,
            has_line_number = true,
          })
        end

        -- Opencode setup
        local ok_opencode, opencode = pcall(require, "opencode")
        if ok_opencode then
          vim.g.opencode_opts = {}
        end

        -- Smear cursor setup
        local ok_smear, smear = pcall(require, "smear-cursor")
        if ok_smear then
          smear.setup({})
        end

        -- Supermaven setup
        local ok_supermaven, supermaven = pcall(require, "supermaven-nvim")
        if ok_supermaven then
          supermaven.setup({
            keymaps = {
              accept_suggestion = "<C-l>",
              clear_suggestion = "<C-]>",
              accept_word = "<C-j>",
            },
            disable_inline_completion = false,
          })
        end

        -- Laravel.nvim setup
        local ok_laravel, laravel = pcall(require, "laravel")
        if ok_laravel then
          laravel.setup({
            features = {
              pickers = {
                provider = "telescope",
              },
            },
            extensions = {
              diagnostic = { enable = false },
            },
          })

          -- Make Laravel global
          _G.Laravel = laravel

          -- Laravel gf mapping
          vim.keymap.set("n", "gf", function()
            local ok, res = pcall(function()
              if laravel.app("gf").cursorOnResource() then
                return "<cmd>lua Laravel.commands.run('gf')<cr>"
              end
            end)
            if not ok or not res then
              return "gf"
            end
            return res
          end, { expr = true, noremap = true })
        end

        -- Telescope extensions setup
        local telescope = require("telescope")

        -- Load smart history if available
        pcall(telescope.load_extension, "smart_history")

        -- Load cmdline if available
        pcall(telescope.load_extension, "cmdline")
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
        alejandra # Nix formatter (or use nixpkgs-fmt)
        gotools # provides goimports
        gofumpt # Go formatter
        nodePackages.eslint_d

        # Linters
        phpstan

        # Git
        lazygit

        # Build tools (for some plugins)
        gnumake
        gcc

        # SQLite for telescope history
        sqlite
      ];

      # Extra plugins not in nixvim
      extraPlugins = with pkgs.vimPlugins; [
        SchemaStore-nvim
        nvim-highlight-colors

        # CodeSnap - code screenshots
        (pkgs.vimUtils.buildVimPlugin {
          pname = "codesnap.nvim";
          version = "v1.6.3";
          src = pkgs.fetchFromGitHub {
            owner = "mistricky";
            repo = "codesnap.nvim";
            rev = "v1.6.3";
            sha256 = "sha256-VHH1jQczzNFiH+5YflhU9vVCkEUoKciV/Z/n9DEZwiY=";
          };
          buildPhase = "make";
        })

        # Opencode - Claude integration
        (pkgs.vimUtils.buildVimPlugin {
          pname = "opencode.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "nickjvandyke";
            repo = "opencode.nvim";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Smear cursor - smooth cursor animation
        (pkgs.vimUtils.buildVimPlugin {
          pname = "smear-cursor.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "sphamba";
            repo = "smear-cursor.nvim";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Supermaven - AI completion
        (pkgs.vimUtils.buildVimPlugin {
          pname = "supermaven-nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "supermaven-inc";
            repo = "supermaven-nvim";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Vim textobj user - required for xmlattr
        (pkgs.vimUtils.buildVimPlugin {
          pname = "vim-textobj-user";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "kana";
            repo = "vim-textobj-user";
            rev = "master";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Vim textobj xmlattr - text objects for XML attributes
        (pkgs.vimUtils.buildVimPlugin {
          pname = "vim-textobj-xmlattr";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "whatyouhide";
            repo = "vim-textobj-xmlattr";
            rev = "master";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Laravel.nvim - Laravel development tools
        (pkgs.vimUtils.buildVimPlugin {
          pname = "laravel.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "adalessa";
            repo = "laravel.nvim";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # Laravel dependencies
        vim-dotenv
        nui-nvim
        nvim-nio
        plenary-nvim

        # Telescope extensions
        telescope-smart-history-nvim
        (pkgs.vimUtils.buildVimPlugin {
          pname = "telescope-cmdline.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "jonarrien";
            repo = "telescope-cmdline.nvim";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })

        # SQLite for telescope history
        sqlite-lua
      ];
    };
  };
}
