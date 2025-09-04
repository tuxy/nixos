{pkgs, ...}: let
  profile = import ../../user/profile.nix {};
in {
  wsl = {
    enable = true;
    defaultUser = profile.name;
  };

  users.users."${profile.name}" = {
    shell = pkgs.fish;
    ignoreShellProgramCheck = true; # fix performance issues
  };

  # Programs & packages
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa
    ];
  };

  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "windowsputer";
  system.stateVersion = "25.11";
}
