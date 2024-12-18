{ config, pkgs, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install firefox.
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  imports = [
    ./apps/games.nix
    ./apps/development.nix
    ./apps/general.nix
    ./apps/home.nix
  ];
}
