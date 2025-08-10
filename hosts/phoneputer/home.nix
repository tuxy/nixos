{lib, pkgs, ...}: let
  profile = import ../../user/profile.nix {};
in {
  imports = [
    ../../modules/home-manager/neovim
    ../../modules/home-manager/shell
    ../../modules/home-manager/packages/cli
  ];

  home = {
    username = lib.mkDefault profile.name;
    homeDirectory = lib.mkDefault "/home/${profile.name}";
    packages = with pkgs; [
      ncurses
      nerd-fonts.fira-code
    ];
    stateVersion = "24.11";
  };
}
