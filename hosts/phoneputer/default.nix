{pkgs, ...}: {
  environment.packages = with pkgs; [
    wget
    curl
    git
  ];

  terminal.font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";

  environment.etcBackupExtension = ".bak";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  user.shell = "${pkgs.fish}/bin/fish";

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };

  system.stateVersion = "24.05";
}
