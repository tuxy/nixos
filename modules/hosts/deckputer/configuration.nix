{ self, inputs, ... }:
{
  flake.nixosModules.deckputerConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix
        self.diskoConfigurations.deckputer
        self.nixosModules.deckputerHardware
        self.nixosModules.deckMode
        self.nixosModules.flatpaks
        self.nixosModules.neovim
        self.nixosModules.borg
        self.nixosModules.ldenv
        self.nixosModules.packages-all
        self.nixosModules.desktop
        self.nixosModules.firefox
        self.nixosModules.printing
        self.nixosModules.user
        self.nixosModules.shell
        self.nixosModules.gaming
        self.nixosModules.syncthing
      ];

      boot.plymouth = {
        enable = true;
        theme = lib.mkForce "bgrt";
      };

      boot.loader.systemd-boot.enable = true;

      nix.settings = {
        trusted-users = [
          "root"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      hardware.i2c.enable = true;

      nixpkgs.config.allowUnfree = true;

      services.sshd.enable = true;
      services.upower.enable = true;
      services.tailscale.enable = true;

      hardware.bluetooth.enable = true;
      networking.networkmanager.enable = true;
      services.blueman.enable = true;
      services.automatic-timezoned.enable = true;

      networking.hostName = "deckputer";
      networking.firewall.allowedTCPPorts = [ ];
      networking.firewall.allowedUDPPorts = [ ];
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
      ];

      system.stateVersion = "26.05";
    };
}
