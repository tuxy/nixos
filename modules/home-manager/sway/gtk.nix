{ pkgs, lib, ... }:
let
  theme = import ./theme.nix { };
in
{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  gtk = {
    enable = true;
  };
}
