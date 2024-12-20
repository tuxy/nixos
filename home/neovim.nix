{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    rust-analyzer
  ];

  programs.neovim = {
    enable = true;
  };
}
