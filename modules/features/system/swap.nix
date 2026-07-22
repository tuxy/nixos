{ ... }: {
  flake.nixosModules.swap = { pkgs, ... }: {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
      }
    ];

    boot.zswap.enable = true;
    zramSwap.enable = false;
  };
}
