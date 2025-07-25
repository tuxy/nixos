{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  inputs.home-manager.users.tuxy = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ./dconf.nix
      ./packages.nix
      ./chromium.nix
      ./neovim/neovim.nix
      ./shell.nix
      ./vscode.nix
      inputs.nixvim.homeManagerModules.nixvim
    ];

    home = {
      username = "tuxy";
      homeDirectory = "/home/tuxy";

      stateVersion = "24.11";
    };

    programs.git.enable = true;
  };
}
