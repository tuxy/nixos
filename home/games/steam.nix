{ config, pkgs, ... }:{  
  environment.systemPackages = with pkgs; [
    steam
  ];

  # Steam packages
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
