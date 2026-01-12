{ pkgs, ... }:
let
  profile = import ../../user/profile.nix { };
in
{
  imports = [
    # Hardware-ish configuration
    ./basic.nix

    # Importing modules (all of them...)
    ./hardware-configuration.nix
     ../../modules/nixos/sway
    #../../modules/nixos/gnome
    # ../../modules/nixos/plasma
    ../../modules/nixos/disko
    ../../modules/nixos/thunar
    ../../modules/nixos/packages
    ../../modules/nixos/nvidia
    ../../modules/nixos/ld
    ../../modules/nixos/virt
    ../../modules/nixos/print
  ];
  users.users.${profile.name} = {
    isNormalUser = true;
    description = profile.name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # Game stuff
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.lsfg-vk = {
    enable = true;
  };

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  services.flatpak.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;
  jovian.decky-loader.enable = true;

  catppuccin.enable = true;

  nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.tailscale.enable = true;

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  system.stateVersion = "25.11";
}
