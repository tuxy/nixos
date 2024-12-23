{
  config,
  pkgs,
  ...
}: {
  # Installing lsp s
  home.packages = with pkgs; [
    rust-analyzer
    python312Packages.python-lsp-server
    nil
    ccls
  ];

  # Enable lsp and lsp-format in nixvim
  programs.nixvim.plugins = {
    lsp.enable = true;
    lsp-format.enable = true;
  };
}
