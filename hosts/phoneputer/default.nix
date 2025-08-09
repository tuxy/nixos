{pkgs, ...}: let
  profile = import ../../user/profile.nix {};
in {
  environment.packages = with pkgs; [
    neovim
    wget
    curl
    git
  ];

  environment.etcBackupExtension = ".bak";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  user = {
    userName = profile.name;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };

  system.stateVersion = "24.05";
}
