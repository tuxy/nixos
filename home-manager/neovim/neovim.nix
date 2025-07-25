{...}: {
  imports = [./lsp.nix ./cmp.nix];

  programs.nixvim = {
    enable = true;
    plugins = {
      # Basic plugins
      telescope.enable = true;
      treesitter.enable = true;
      web-devicons.enable = true;
      hardtime.enable = true;
      lualine.enable = true;
      scrollview.enable = true;
    };
  };
}
