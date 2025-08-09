{pkgs, ...}: let
  profile = import ../../user/profile.nix {};
in {
  imports = [
    # Hardware-ish configuration
    ./basic.nix

    # Importing modules (all of them...)
    ./hardware-configuration.nix
    ../../modules/nixos/sway
    ../../modules/nixos/disko
    # ../../modules/nixos/gnome
    ../../modules/nixos/thunar
    ../../modules/nixos/packages
  ];
  users.users.${profile.name} = {
    isNormalUser = true;
    description = profile.name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Game stuff
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.lsfg-vk = {
    enable = true;
    ui.enable = true;
  };

  services.flatpak.enable = true;
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [67];
  system.stateVersion = "24.11"; # Did you read the comment?
}
