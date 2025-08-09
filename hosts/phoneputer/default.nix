{
  pkgs,
  ...
}:
{
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

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };  

  system.stateVersion = "24.05";
}
