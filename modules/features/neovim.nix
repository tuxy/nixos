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
      ...
    }:
    let
      nvf' = inputs.nvf.lib.neovimConfiguration {
        pkgs = pkgs;
        modules = [
          {
            config.vim = {
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
              filetree.nvimTree.enable = true;

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
