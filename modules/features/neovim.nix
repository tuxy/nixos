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
              treesitter.enable = true;
              statusline.lualine.enable = true;
              filetree.neo-tree = {
                enable = true;
                setupOpts = {
                  close_if_last_window = true;
                  enable_git_status = true;
                  enable_diagnostics = true;
                  filesystem = {
                    hijack_netrw_behavior = "open_current";
                  };
                  window = {
                    position = "current";
                  };
                };
              };

              keymaps = [
                {
                  key = "<leader>e";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>Neotree position=current<CR>";
                  desc = "Toggle neo-tree netrw-style";
                }
                {
                  key = "<leader>t";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>tabnew | Neotree position=current<CR>";
                  desc = "New tab with netrw";
                }
                {
                  key = "<leader>f";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
                  desc = "Search for function symbols";
                }
                {
                  key = "<leader>q";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>tabnew | terminal<CR>";
                  desc = "Search for function symbols";
                }
                {
                  key = "<leader>g";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>Telescope live_grep<CR>";
                  desc = "Search for anything really";
                }
                {
                  key = "<C-w>v";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>vsplit | Neotree position=current<CR>";
                  desc = "Vertical split with netrw";
                }
                {
                  key = "<C-w>s";
                  mode = "n";
                  silent = true;
                  action = "<Cmd>split | Neotree position=current<CR>";
                  desc = "Horizontal split with netrw";
                }
              ];

              autocmds = [
                {
                  event = [ "VimEnter" ];
                  pattern = [ "*" ];
                  command = "Neotree position=current";
                  desc = "Open neo-tree on startup";
                }
                {
                  event = [ "VimEnter" ];
                  pattern = [ "*" ];
                  command = "colorscheme onedark_dark";
                  desc = "theme on start";
                }
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
