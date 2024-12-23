{
  config,
  pkgs,
  ...
}: {
  imports = [./lsp.nix];

  programs.nixvim = {
    enable = true;
    plugins = {
      # Basic plugins
      telescope.enable = true;
      treesitter.enable = true;
      web-devicons.enable = true;
      hardtime.enable = true;
    };
  };
}
