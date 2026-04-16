{self, ...}: {
  flake.nixosModules.user = {pkgs, ...}: {
    users = {
      mutableUsers = false;
      users.tuxy = {
        initialPassword = "1234";
        isNormalUser = true;
        description = "tuxy";
        extraGroups = [
          "networkmanager"
          "wheel"
          "syncthing"
          "libvirtd"
        ];
        shell = pkgs.fish;
      };
    };

    nix.settings.trusted-users = [
      "tuxy"
    ];
  };
}
