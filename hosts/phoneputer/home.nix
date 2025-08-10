{
  lib,
  config,
  pkgs,
  ...
}: let
  profile = import ../../user/profile.nix {};
in {
  imports = [
    ../../modules/home-manager/neovim
    ../../modules/home-manager/shell
    ../../modules/home-manager/packages/cli
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = lib.mkDefault profile.name;
    homeDirectory = lib.mkDefault "/home/${profile.name}";

    packages = with pkgs; [
      ncurses # for fixing clear functionality
      fontconfig
      alejandra
    ];

    stateVersion = "24.11";
  };
}
