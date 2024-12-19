{pkgs, ...}: let
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  # install packages
  environment.systemPackages = with pkgs; [ # or home.packages
    wine-wayland
    wine-staging
    wine64
    wine
    winetricks
  ];
}
