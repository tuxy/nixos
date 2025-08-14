{pkgs, ...}: {
  # Include language servers here
  home.packages = with pkgs; [
    rust-analyzer
    pylyzer
    nil
    ccls
  ];

  programs.nixvim = {
    imports = [
      ./lsp.nix
      ./cmp.nix
    ];

    enable = true;
    plugins = {
      # Basic plugins
      telescope.enable = true;
      treesitter.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      scrollview.enable = true;
    };
  };
}
