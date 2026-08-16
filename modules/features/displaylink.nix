{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.displaylink = { pkgs, config, ... }: {
    environment.systemPackages = with pkgs; [
      displaylink
    ];

    boot = {
      extraModulePackages = [ config.boot.kernelPackages.evdi ];
      initrd.kernelModules = [ "evdi" ];
    };

    services.xserver.videoDrivers = [ "displaylink" ];
    systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  };
}
