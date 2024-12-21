{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    rust-analyzer
  ];

  programs.neovim = {
    enable = true;
  };
}
