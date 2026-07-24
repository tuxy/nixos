{...}: {
  flake.nixosModules.udev = {pkgs, ...}: {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"
    '';
  };
}
