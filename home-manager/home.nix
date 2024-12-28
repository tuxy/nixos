{...}: let
  nixvim = import (builtins.fetchGit {
    # importing nixvim
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-24.11";
  });
in {
  users.users.eve.isNormalUser = true;
  home-manager.users.tuxy = {pkgs, ...}: {
    imports = [
      ./dconf.nix
      ./packages.nix
      ./chromium.nix
      ./neovim/neovim.nix
      ./shell.nix 
      nixvim.homeManagerModules.nixvim
    ];
    home.stateVersion = "24.11";
  };
}
