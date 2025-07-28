{pkgs, ...}: {
  imports = [
    ./base/hardware-configuration.nix
    ./base/basic.nix
    ./base/packages.nix
    ./base/disko-config.nix
    ./base/flatpak.nix
    # ./base/gnome.nix
    ./sway/sway.nix
  ];
  users.users.tuxy = {
    isNormalUser = true;
    description = "tuxy";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  system.stateVersion = "24.11"; # Did you read the comment?
}
