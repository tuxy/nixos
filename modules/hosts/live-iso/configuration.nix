{ self, inputs, ... }:
{
  flake.nixosModules.liveIsoConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
        self.nixosModules.user
        self.nixosModules.shell
      ];

      nixpkgs.hostPlatform = "x86_64-linux";

      isoImage = {
        makeEfiBootable = true;
        makeUsbBootable = true;
        volumeID = "NIXOS_LIVE";
      };

      boot = {
        supportedFilesystems = lib.mkForce [
          "vfat"
          "ext4"
          "btrfs"
          "xfs"
          "ntfs"
        ];
        tmp.cleanOnBoot = true;
      };

      hardware.enableAllHardware = true;
      hardware.bluetooth.enable = true;

      networking = {
        networkmanager.enable = true;
        hostName = "live-iso";
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
        ];
        firewall.allowedTCPPorts = [ ];
        firewall.allowedUDPPorts = [ ];
      };

      services.getty.autologinUser = self.profiles.tuxy.name;

      time.timeZone = self.profiles.tuxy.timeZone;
      console.keyMap = self.profiles.tuxy.layout;

      environment.systemPackages = with pkgs; [
        curl
        wget
        just
        sbctl
        parted
        cryptsetup
        ntfs3g
        e2fsprogs
        neovim
        pciutils
        usbutils
        ethtool
        iproute2
      ];

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      system.stateVersion = "25.11";
    };
}

