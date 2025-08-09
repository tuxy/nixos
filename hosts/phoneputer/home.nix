{...}: let
  profile = import ../../user/profile.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../../modules/home-manager/shell
    ../../modules/home-manager/neovim
    ../../modules/home-manager/packages/cli
  ];

  home = {
    username = profile.name;
    homeDirectory = "/home/${profile.name}";
    stateVersion = "24.11";
  };

  programs.git.enable = true;
}
