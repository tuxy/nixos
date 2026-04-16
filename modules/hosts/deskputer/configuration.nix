{self, ...}: {
  flake.nixosModules.deskputerConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.deskputerHardware
      self.nixosModules.plasma
      # self.nixosModules.packages.all
      # self.nixosModules.desktop
      # self.nixosModules.firefox
      # self.nixosModules.printing
      self.nixosModules.user
      self.nixosModules.shell
      # self.nixosModules.virt
      # self.nixosModules.gaming
      # self.nixosModules.nvidia
    ];

    programs.neovim = {
      enable = true;
      # package = self.packages.${pkgs.stdenv.system}.neovim;
    };

    boot.plymouth = {
      enable = true;
      theme = lib.mkForce "bgrt";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nixpkgs.config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
    };

    nix.settings.trusted-users = [
      "root"
    ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    services.tailscale.enable = true;

    networking.hostName = "deskputer";
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
    networking.nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];

    system.stateVersion = "25.11";
  };
}
