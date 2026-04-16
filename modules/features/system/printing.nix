{...}: {
  flake.nixosModules.printing = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;

    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      canon-cups-ufr2
      gutenprintBin
    ];
  };
}
