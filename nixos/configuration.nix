{pkgs, ...}: {
  imports = [
    ./base/hardware-configuration.nix
    ./base/basic.nix
    ./base/packages.nix
    ./base/disko-config.nix
    ./base/gnome.nix
    # ./sway/sway.nix
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

  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  system.stateVersion = "24.11"; # Did you read the comment?
}
