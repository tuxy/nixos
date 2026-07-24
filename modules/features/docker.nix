{ ... }: {
  flake.nixosModules.docker = { pkgs, ... }: {
    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        storageDriver = "btrfs";
        rootless.enable = false;
      };
    };
  };
}
