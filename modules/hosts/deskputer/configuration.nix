{ self, inputs, ... }:
{
  flake.nixosModules.deskputerConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.deskputerHardware
        # self.nixosModules.plasma
        self.nixosModules.neovim
        # self.nixosModules.packages-all
        self.nixosModules.desktop
        self.nixosModules.firefox
        # self.nixosModules.printing
        self.nixosModules.user
        self.nixosModules.shell
        # self.nixosModules.virt
        # self.nixosModules.gaming
        # self.nixosModules.nvidia
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        self.diskoConfigurations.deskputer
      ];

      boot.plymouth = {
        enable = true;
        theme = lib.mkForce "bgrt";
      };

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };
      environment.systemPackages = [ pkgs.sbctl ];
      services.fwupd.enable = true;
      boot.loader.systemd-boot.enable = lib.mkForce false;

      nixpkgs.config = {
        android_sdk.accept_license = true;
        allowUnfree = true;
      };

      nix.settings = {
        trusted-users = [
          "root"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      services.tailscale.enable = true;
      services.upower.enable = true;
      networking.networkmanager.enable = true;

      networking.hostName = "deskputer";
      networking.firewall.allowedTCPPorts = [ ];
      networking.firewall.allowedUDPPorts = [ ];
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
      ];

      system.stateVersion = "25.11";
    };
}
