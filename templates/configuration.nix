{ self, inputs, ... }:
{
  flake.nixosModules.HOSTNAMEConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        self.diskoConfigurations.HOSTNAME

        self.nixosModules.HOSTNAMEHardware
      ];

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
      networking.networkmanager.enable = true;
      services.blueman.enable = true;
      services.upower.enable = true;
      services.automatic-timezoned.enable = true;

      networking.hostName = "HOSTNAME";
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
