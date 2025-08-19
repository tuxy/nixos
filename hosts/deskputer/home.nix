{...}: let
  profile = import ../../user/profile.nix {};
in {
  home-manager.backupFileExtension = "bak";
  home-manager.users.${profile.name} = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ../../modules/home-manager/dconf
      # ../../modules/home-manager/sway
      ../../modules/home-manager/shell
      ../../modules/home-manager/neovim
      ../../modules/home-manager/browser
      # ../../modules/home-manager/flatpak
      ../../modules/home-manager/packages
      ../../modules/home-manager/tmux
    ];

    home = {
      username = profile.name;
      homeDirectory = "/home/${profile.name}";
      stateVersion = "25.11";
    };

    programs.git.enable = true;
  };
}
