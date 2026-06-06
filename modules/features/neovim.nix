{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.neovim =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
        pkgs.ripgrep
        pkgs.lsof
      ];
    };

  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    let
      nvf' = inputs.nvf.lib.neovimConfiguration {
        pkgs = pkgs;
        modules = [
          {
            config.vim = {
              startPlugins = [
                pkgs.vimPlugins.onedarkpro-nvim
              ];

              extraPlugins = {
                autoclose-nvim = {
                  package = pkgs.vimPlugins.autoclose-nvim;
                  setup = "require('autoclose').setup({
                    options = {
                      auto_indent = true;
                    };
                  })";
                };
                opencode-nvim = {
                  package = pkgs.vimPlugins.opencode-nvim;
                };
              };

              autocomplete.blink-cmp = {
                enable = true;
                friendly-snippets.enable = true;

                setupOpts = {
                  fuzzy.implementation = "prefer_rust";

                  completion.menu.auto_show = true;
                  completion.documentation.auto_show = true;
                  completion.documentation.auto_show_delay_ms = 200;

                  sources.default = [
                    "lsp"
                    "path"
                    "snippets"
                    "buffer"
                    "emoji"
                    "ripgrep"
                  ];

                  sources.providers = {
                    emoji = {
                      module = "blink-emoji";
                    };
                    ripgrep = {
                      module = "blink-ripgrep";
                    };
                  };
                };

                sourcePlugins = {
                  emoji.enable = true;
                  ripgrep.enable = true;
                  spell.enable = true;
                };

                mappings = {
                  complete = "<C-Space>";
                  confirm = "<CR>";
                  next = "<C-n>";
                  previous = "<C-p>";
                  close = "<C-c>";
                  scrollDocsDown = "<C-f>";
                  scrollDocsUp = "<C-b>";
                };

                setupOpts = {
                  cmdline.keymap.preset = "cmdline";
                };
              };

              telescope.enable = true;

              binds = {
                whichKey.enable = true;
                hardtime-nvim.enable = true;
                cheatsheet.enable = true;
              };

              treesitter = {
                enable = true;
                indent.enable = false;
              };
              statusline.lualine.enable = true;
              filetree.neo-tree = {
                enable = true;
                setupOpts = {
                  close_if_last_window = true;
                  enable_git_status = true;
                  enable_diagnostics = true;
                  filesystem = {
                    filtered_items = {
                      visible = true;
                      hide_hidden = false;
                    };
                  };
                  window = {
                    position = "current";
                    mappings = {
                      "H" = "none";
                      "T" = lib.mkLuaInline ''
                        function(state)
                          require('neo-tree.sources.filesystem.commands').open_tabnew(state)
                          vim.schedule(function() vim.cmd("tabprev") end)
                        end
                      '';
                    };
                  };
                };
              };

              keymaps =
                let
                  mkKeymap = key: action: desc: {
                    inherit key action desc;
                    mode = "n";
                    silent = true;
                  };
                  mkLuaKeymap = key: action: desc: {
                    inherit key action desc;
                    mode = "n";
                    silent = true;
                    lua = true;
                  };
                  mkVizKeymap = key: action: desc: {
                    inherit key action desc;
                    mode = "v";
                    silent = true;
                    lua = true;
                  };
                in
                [
                  # basic keys
                  (mkKeymap "<leader>e" "<Cmd>Neotree position=current<CR>" "Toggle neo-tree")
                  (mkKeymap "<leader>t" "<Cmd>tabnew | Neotree position=current<CR>" "New tab with neo-tree")
                  (mkKeymap "<leader>q" "<Cmd>tabnew | terminal<CR>" "New tab with neo-tree")
                  (mkKeymap "<C-w>v" "<Cmd>vsplit | Neotree position=current<CR>" "Vertical split with neo-tree")
                  (mkKeymap "<C-w>s" "<Cmd>split | Neotree position=current<CR>" "Horizontal split with neo-tree")
                  (mkKeymap "<leader>f" "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>" "Search for functions")
                  (mkKeymap "<leader>g" "<Cmd>Telescope live_grep<CR>" "Search text")
                  (mkKeymap "L" "<Cmd>tabnext<CR>" "Next tab")
                  (mkKeymap "H" "<Cmd>tabprev<CR>" "Previous tab")

                  # opencode
                  (mkVizKeymap "<leader>oa" "function() require('opencode').ask('@this: ', { submit = true }) end"
                    "Ask opencode about selection"
                  )
                  (mkLuaKeymap "<leader>ox" "function() require('opencode').select() end" "Execute opencode action")
                  (mkLuaKeymap "<leader>ot" "function() require('opencode').toggle() end" "Toggle opencode")
                  (mkVizKeymap "go" "require('opencode').operator('@this ')" "Add visual range to opencode")
                  (mkLuaKeymap "goo" "require('opencode').operator('@this ') .. '_'" "Add line to opencode")
                ];

              autocmds =
                let
                  mkVimEnter = command: desc: {
                    event = [ "VimEnter" ];
                    pattern = [ "*" ];
                    inherit command desc;
                  };
                in
                [
                  # (mkVimEnter "Neotree position=current" "Open neo-tree on startup")
                  (mkVimEnter "colorscheme onedark_dark" "Theme on startup")
                  (mkVimEnter "tnoremap <Esc> <C-\\><C-n>" "Rebind terminal escape")
                ];

              lsp = {
                enable = true;
                formatOnSave = true;
                lspconfig.enable = true;
              };

              languages = {
                nix.enable = true;
                rust.enable = true;
                clang.enable = true;
                python.enable = true;
                typst.enable = true;
                markdown = {
                  enable = true;
                };
              };
            };
          }
        ];
      };
    in
    {
      packages.neovim = nvf'.neovim;
    };
}
