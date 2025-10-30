{...}: let
  profile = import ../../user/profile.nix {};
in {
  home-manager.backupFileExtension = "bak";
  home-manager.users.${profile.name} = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ../../modules/home-manager/shell
      ../../modules/home-manager/neovim
      ../../modules/home-manager/packages/cli
      ../../modules/home-manager/packages/dev
      ../../modules/home-manager/tmux
    ];

    home = {
      username = profile.name;
      homeDirectory = "/home/${profile.name}";
      #sessionVariables = {
      #};

      stateVersion = "25.11";
    };

    programs.git.enable = true;
  };
}
