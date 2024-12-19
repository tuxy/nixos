{ config, pkgs, ... }:{
  
  imports = [ ./lutris.nix ];

  environment.systemPackages = with pkgs; [
    steam
    lutris
  ];

  # Steam packages
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
