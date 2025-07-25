{
  inputs,
  lib,
  config,
  pkgs,
}: {
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

  programs.home-manager.enable = true;
  programs.git.enable = true;
}
